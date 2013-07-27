%% -*- coding: utf-8 -*-
-module(service_zonnet_callslist).
-author("Kirill Sysoev").
-svc_title("Calls list.").
-svc_needauth(false).

-export([process_get/2]).

-include_lib("zotonic.hrl").

process_get(_ReqData, Context) ->
    case z_context:get_q("phone_number", Context) of
        undefined ->
            {error, missing_arg, "phone_number"};
        [] ->
            {error, missing_arg, "phone_number"};
        Phone_Number ->
            QueryString = io_lib:format("select 1 from all_phones_status where ocupated_date = '0000-00-00' and state = 1 and publish = 1 and number_id like '%~s'", [Phone_Number]),
            file:write_file("/home/zotonic/marfatalk",QueryString),
            case z_mydb:q(QueryString, Context) of
                [[1]] -> 
                    {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
                    Reply = [{"callslist", z_convert:to_json(zonnet_analytics:get_call_attempts_by_retrodays(Phone_Number, {Year, Month, Day}, 30, Context))}],
                    {struct, Reply};
                _ ->
                    {error,  access_denied, undefined}
            end
    end.

