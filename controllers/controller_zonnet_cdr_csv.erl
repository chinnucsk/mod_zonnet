-module(controller_zonnet_cdr_csv).

-export([
    init/1,
    service_available/2,
    allowed_methods/2,
    encodings_provided/2,
    resource_exists/2,
    forbidden/2,
    expires/2,
    content_types_provided/2,
    charsets_provided/2,
    provide_content/2
]).

-include_lib("controller_webmachine_helper.hrl").
-include_lib("include/zotonic.hrl").

%% Let cached versions expire in an hour.
-define(MAX_AGE, 3600).


init(DispatchArgs) ->
    {ok, DispatchArgs}.

service_available(ReqData, DispatchArgs) when is_list(DispatchArgs) ->
    Context  = z_context:new(ReqData, ?MODULE),
    Context1 = z_context:set(DispatchArgs, Context),
    Context2 = z_context:ensure_all(Context1),
    ?WM_REPLY(true, Context2).


allowed_methods(ReqData, Context) ->
    {['HEAD', 'GET'], ReqData, Context}.


charsets_provided(ReqData, Context) ->
    {[{"utf-8", fun(X) -> X end}], ReqData, Context}.


encodings_provided(ReqData, Context) ->
    {[
        {"identity", fun(X) -> X end}, 
        {"gzip", fun(X) -> zlib:gzip(X) end}
    ], ReqData, Context}.


content_types_provided(ReqData, Context) ->
    {[{"text/csv", provide_content}], ReqData, Context}.


resource_exists(ReqData, Context) ->
    Context1 = ?WM_REQ(ReqData, Context),
   ?WM_REPLY(true, Context1).


%% @doc Check if the current user is allowed to view the resource. 
forbidden(ReqData, Context) ->
    Context1 = ?WM_REQ(ReqData, Context),
    ?WM_REPLY(not zonnet_util:is_valid_account(Context1), Context1).

expires(ReqData, State) ->
    NowSecs = calendar:datetime_to_gregorian_seconds(calendar:universal_time()),
    {calendar:gregorian_seconds_to_datetime(NowSecs - 1), ReqData, State}.

provide_content(ReqData, Context) ->
    CallsType = z_context:get_q("callstype", Context),
    Direction = z_context:get_q("callsdirection", Context),
    StartDayInput = z_context:get_q("startDayInput", Context),
    EndDayInput = z_context:get_q("endDayInput", Context),
    MonthInput = z_context:get_q("monthInput", Context),
    Filename = lists:flatten(["cdr_export",".csv"]),
    RD1 = wrq:set_resp_header("Content-Disposition", "inline; filename="++Filename, ReqData),
    Context1 = ?WM_REQ(RD1, Context),
    Data = zonnet_util:calls_list_query({callsdirection,Direction},{callstype,CallsType},{from,StartDayInput},{limit,"300000"},{month,MonthInput},{till,EndDayInput}, Context),
    FullData = [[<<"timefrom">>, <<"numfrom">>, <<"numto">>, <<"duration">>, <<"direction">>, <<"amount">>] | Data],
    Content = to_csv(FullData),
    ?WM_REPLY(Content, Context1).

to_csv(Rows) ->
    to_csv(Rows, <<>>).

to_csv([], Acc) ->
    Acc;
to_csv([R|Rows], Acc) ->
    RB = to_csv_row(R),
    to_csv(Rows, <<Acc/binary, RB/binary, 10>>).

to_csv_row(R) ->
    to_csv_row(R, <<>>).

to_csv_row([], Acc) ->
    Acc;
to_csv_row([V], Acc) ->
    B = filter(V),
    <<Acc/binary, B/binary>>;
to_csv_row([V|Vs], Acc) ->
    B = filter(V),
    to_csv_row(Vs, <<Acc/binary, B/binary, $,>>).

filter({datetime,{{Y,M,D}, {H,I,S}}})
        when is_integer(Y), is_integer(M), is_integer(D),
                 is_integer(H), is_integer(I), is_integer(S) ->
        list_to_binary(io_lib:format("~w-~2..0w-~2..0w ~2B:~2.10.0B:~2.10.0B",[Y, M, D, H, I, S]));
filter(V) when is_integer(V); is_atom(V); is_float(V) ->
    z_convert:to_binary(V);
filter(V) ->
    B = escape(z_convert:to_binary(V), <<$">>),
    <<B/binary, $">>.
    
escape(<<>>, Acc) ->
    Acc;
escape(<<10, Rest/binary>>, Acc) ->
    escape(Rest, <<Acc/binary, 10>>);
escape(<<13, Rest/binary>>, Acc) ->
    escape(Rest, Acc);
escape(<<$\\, Rest/binary>>, Acc) ->
    escape(Rest, <<Acc/binary, $\\, $\\>>);
escape(<<$", Rest/binary>>, Acc) ->
    escape(Rest, <<Acc/binary, $", $">>);
escape(<<C, Rest/binary>>, Acc) when C =< 32 ->
    escape(Rest, <<Acc/binary, 32>>);
escape(<<C, Rest/binary>>, Acc) ->
    escape(Rest, <<Acc/binary, C>>).

