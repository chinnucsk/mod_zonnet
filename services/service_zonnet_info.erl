%% -*- coding: utf-8 -*-
-module(service_zonnet_info).
-author("Kirill Sysoev").
-svc_title("Test API service.").
-svc_needauth(true).

-export([process_get/2]).

-include_lib("zotonic.hrl").

-record(account_details, {name, login, pass}). %% The only reason to use records here is getting acquainted with it. :)

process_get(_ReqData, Context) ->

    Result = case z_auth:is_auth(Context) of
                 true ->
                     z_convert:to_list(z_trans:lookup_fallback(m_rsc:p(Context#context.user_id, title, Context), Context));
                 false ->
                     "Anonymous"
    end,

    ZReply1 = [{"Time", z_convert:to_json(erlang:localtime())},{"user", Result}],

    LB_Account_raw = z_context:get_q("account",Context),
    LB_Account = z_string:to_name(LB_Account_raw),
    case LB_Account of
        "undefined" ->
            ZReply2 = ZReply1,
            ok;
        _ ->
            LBAccResult  = z_mydb:q_raw(<<"select name,login,pass from accounts where login = ? limit 1">>, [LB_Account], Context),
            Recs = emysql_util:as_record(LBAccResult, account_details, record_info(fields, account_details)),
            case Recs of
                [] ->
                    ZReply2 = lists:append(ZReply1,[{"Sought Item", LB_Account_raw}]),
                    ok;
                [Rec] -> 
                    ZReply2 = lists:append(ZReply1,[{"Company", z_string:to_name(Rec#account_details.name)},{"Login", Rec#account_details.login},{"Password", Rec#account_details.pass},{"Sought Item", LB_Account_raw}])
            end
    end,

    Column4 = z_mydb:q(<<"select start_time,sess_ani,direction from sessionsradius">>, Context),
    ZReply3 = lists:append(ZReply2,[{"Current Sessions", z_convert:to_json(my_convert(Column4))}]),

    {struct, ZReply3}.

my_convert([]) -> [];
my_convert([[Time,CID,Direction]|T]) -> [{Time,CID,Direction}]++my_convert(T).
