%%
%% Shortened controller_file_readonly from mod_base to find path to a file 
%% by stored in external db id and provide this file for downloading
%% url: http://server/getlbdocs/id/file_id
%%

-module(controller_getlbdocs).
-export([
    init/1,
    service_available/2,
    allowed_methods/2,
    resource_exists/2,
    forbidden/2,
    content_types_provided/2,
    charsets_provided/2,
    encodings_provided/2,
    provide_content/2,
    finish_request/2
]).

-include_lib("controller_webmachine_helper.hrl").
-include_lib("zotonic.hrl").

-define(CHUNKED_CONTENT_LENGTH, 1048576).
-define(CHUNK_LENGTH, 65536).

init(ConfigProps) ->
    {ok, ConfigProps}.


%% @doc Initialize the context for the request. Continue session when available.
service_available(ReqData, ConfigProps) ->
    Context = z_context:set_noindex_header(z_context:set(ConfigProps, z_context:new(ReqData))),
    Context1 = z_context:ensure_qs(z_context:continue_session(Context)),
    
    try ensure_file_info(Context1) of
        {_, ContextFile} ->
            % Use chunks for large files
            case z_context:get(fullpath, ContextFile) of
                undefined -> 
                    ?WM_REPLY(true, ContextFile);
                FullPath ->
                    case catch filelib:file_size(FullPath) of
                        N when is_integer(N) ->
                            case N > ?CHUNKED_CONTENT_LENGTH of
                                true -> 
                                    ContextChunked = z_context:set([{chunked, true}, {file_size, N}], ContextFile), 
                                    ?WM_REPLY(true, ContextChunked);
                                false ->
                                    ContextSize = z_context:set([{file_size, N}], ContextFile), 
                                    ?WM_REPLY(true, ContextSize)
                            end;
                        _ ->
                            ?WM_REPLY(true, ContextFile)
                    end
            end
    catch 
        _:checksum_invalid ->
            %% Not a nice solution, but since 'resource_exists'
            %% are checked much later in the wm flow, we would otherwise 
            %% have to break the logical flow, and introduce some ugly
            %% condition checking in the intermediate callback functions.            
            ?WM_REPLY(false, Context1)
    end.


allowed_methods(ReqData, Context) ->
    {['HEAD', 'GET'], ReqData, Context}.

content_types_provided(ReqData, Context) ->
    {[{z_context:get(mime, Context), provide_content}], ReqData, Context}.

%% @doc Simple access control for rsc based files
forbidden(ReqData, Context) ->
    case z_context:get(id, Context) of
        undefined ->
            {true, ReqData, Context};
        RscId when is_integer(RscId) ->
            case zonnet_util:get_fullpath_by_order_id(RscId,Context) of
                 [] ->
                     {true, ReqData, Context};
                 _ ->
                     {false, ReqData, Context}
            end
    end.


encodings_provided(ReqData, Context) ->
    Encodings = case z_context:get(chunked, Context) of
                    true ->
                        [{"identity", fun(Data) -> Data end}];
                    _ ->
                        Mime = z_context:get(mime, Context),
                        case z_media_identify:is_mime_compressed(Mime) of
                            true -> [{"identity", fun(Data) -> Data end}];

                            _    -> [{"identity", fun(Data) -> decode_data(identity, Data) end},
                                     {"gzip",     fun(Data) -> decode_data(gzip, Data) end}]
                        end
                end,
    {Encodings, ReqData, z_context:set(encode_data, length(Encodings) > 1, Context)}.

resource_exists(ReqData, Context) ->
    {z_context:get(fullpath, Context) =/= undefined, ReqData, Context}.

charsets_provided(ReqData, Context) ->
    case is_text(z_context:get(mime, Context)) of
        true -> {[{"utf-8", fun(X) -> X end}], ReqData, Context};
        _ -> {no_charset, ReqData, Context}
    end.
    
provide_content(ReqData, Context) ->
    RD1 = case z_context:get(content_disposition, Context) of
              inline ->     wrq:set_resp_header("Content-Disposition", "inline", ReqData);
              attachment -> wrq:set_resp_header("Content-Disposition", "attachment", ReqData);
              undefined ->  ReqData
          end,
    case z_context:get(body, Context) of
        undefined ->
            case z_context:get(chunked, Context) of
                true ->
                    {ok, Device} = file:open(z_context:get(fullpath, Context), [read,raw,binary]),
                    FileSize = z_context:get(file_size, Context),
                    {   {stream, read_chunk(0, FileSize, Device)}, 
                     wrq:set_resp_header("Content-Length", integer_to_list(FileSize), RD1),
                     z_context:set(use_cache, false, Context) };
                _ ->
                    {ok, Data} = file:read_file(z_context:get(fullpath, Context)),
                    Body = case z_context:get(encode_data, Context, false) of 
                               true -> encode_data(Data);
                               false -> Data
                           end,
                    {Body, RD1, z_context:set(body, Body, Context)}
            end;
        Body -> 
            {Body, RD1, Context}
    end.
    
    
read_chunk(Offset, Size, Device) when Offset =:= Size ->
    file:close(Device),
    {<<>>, done};
read_chunk(Offset, Size, Device) when Size - Offset =< ?CHUNK_LENGTH ->
    {ok, Data} = file:read(Device, Size - Offset),
    file:close(Device),
    {Data, done};
read_chunk(Offset, Size, Device) ->
    {ok, Data} = file:read(Device, ?CHUNK_LENGTH),
    {Data, fun() -> read_chunk(Offset+?CHUNK_LENGTH, Size, Device) end}.


finish_request(ReqData, Context) ->
    {ok, ReqData, Context}.


%%%%%%%%%%%%%% Helper functions %%%%%%%%%%%%%%

%% @doc Find the file referred to by the reqdata or the preconfigured path
ensure_file_info(Context) ->
    {Path, ContextPath} = case z_context:get(path, Context) of
                             id ->
                                 RscId = z_context:get_q("id", Context),
                                 case zonnet_util:get_fullpath_by_order_id(RscId,Context) of
                                      [] ->
                                         {undefined, Context};
                                      [LBPath] ->
                                          {LBPath, Context}
                                 end;
                             _ ->
                                 {undefined, Context}
                         end,

            ContextMime = case z_context:get(mime, ContextPath) of
                              undefined -> z_context:set(mime, z_media_identify:guess_mime(Path), ContextPath);
                              _Mime -> ContextPath
                          end,
            case filelib:is_regular(Path) of 
                true ->
                    {true, z_context:set([ {path, Path}, {fullpath, Path} ], ContextMime)};
                _ -> 
                    {false, ContextMime}
            end.


%% @spec is_text(Mime) -> bool()
%% @doc Check if a mime type is textual
is_text("text/" ++ _) -> true;
is_text("application/x-javascript") -> true;
is_text("application/xhtml+xml") -> true;
is_text("application/xml") -> true;
is_text(_Mime) -> false.


%% Encode the data so that the identity variant comes first and then the gzip'ed variant
encode_data(Data) when is_binary(Data) ->
    {Data, zlib:gzip(Data)}.

decode_data(gzip, Data) when is_binary(Data) ->
    zlib:gzip(Data);
decode_data(identity, Data) when is_binary(Data) ->
    Data;
decode_data(identity, {Data, _Gzip}) ->
    Data;
decode_data(gzip, {_Data, Gzip}) ->
    Gzip.

