-module(m_zonnet).
-author("kirill.sysoev@gmail.com").

-behaviour(gen_model).

%% interface functions
-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).

-include_lib("zotonic.hrl").

m_find_value({accounts_table,[{fields,Fields},{limit,Limit}]}, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("select ~s from accounts where login = \'~s\' limit ~p",[list_to_atom(Fields),Z_User,Limit])),
            [QueryResult] = z_mydb:q(QueryString, Context),
            QueryResult
    end;
m_find_value({accounts_addr_table,[{type,Type}]}, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("select address from accounts_addr where uid = (select uid from accounts where login = \'~s\' limit 1) and type = ~p limit 1",[Z_User,Type])),
            [QueryResult] = z_mydb:q(QueryString, Context),
            QueryResult
    end;
m_find_value(agreements_table, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("SELECT agreements.number, agreements.date, accounts.name FROM agreements, accounts where accounts.uid=agreements.oper_id and agreements.uid = (select uid from accounts where login = \'~s\' limit 1) and agreements.archive = 0",[Z_User])),
            QueryResult = z_mydb:q(QueryString, Context),
            QueryResult
    end;
m_find_value(account_balance, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("SELECT FORMAT(COALESCE(sum(balance),0),2) FROM agreements  where uid = (select uid from accounts where login = \'~s\' limit 1) and agreements.archive = 0",[Z_User])),
            [QueryResult] = z_mydb:q(QueryString, Context),
            QueryResult
    end;
m_find_value(account_payments, _M, Context) -> 
    m_find_value({account_payments,[{limit,1000}]}, _M, Context);
m_find_value({account_payments,[{limit,Limit}]}, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryResult = z_mydb:q(<<"SELECT amount, left(pay_date,10), if(comment like '%assist%','Система Ассист',
                'Безналичный платеж') as comment FROM payments where agrm_id = (SELECT agrm_id from agreements 
                 where uid  = (select uid from accounts where login = ? limit 1) and oper_id = 1)
                ORDER BY LEFT( pay_date, 10 ) DESC limit ?">>,[Z_User,Limit], Context),
            QueryResult
    end;
m_find_value(credit_info, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q(<<"select agrm_id,amount,prom_date,prom_till,debt,pay_id from promise_payments where debt != 0 and agrm_id = (select agrm_id from agreements where oper_id = 1 and archive =0 and uid = (select uid from accounts where login = ? limit 1)) limit 1">>,[Z_User], Context) of
                [[Agrm_id,Amount,Prom_date,Prom_till,Debt,Pay_id]] -> [[Agrm_id,Amount,Prom_date,Prom_till,Debt,Pay_id]];
                   _   -> []
            end
    end;
m_find_value(credit_able, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q(<<"select group_id from usergroups_staff where uid = (select uid from accounts 
                                   where login = ? limit 1) and group_id = 10">>,[Z_User], Context) of
                [[10]] -> true;
                   _   -> false
            end
    end;
m_find_value(credit_allowed, _M, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q(<<"select group_id from usergroups_staff where uid = (select uid from accounts 
                                   where login = ? limit 1) and group_id = 10">>,[Z_User], Context) of
                [[10]] ->
                    case z_mydb:q(<<"select sum(debt) from promise_payments where agrm_id = 
                                     (select agrm_id from agreements where oper_id = 1 and archive =0 and 
                                     uid = (select uid from accounts where login = ? limit 1))">>,
                                                                                 [Z_User], Context) of
                        [[0]] -> true;
                         _  -> false
                    end;
                  _  -> false
            end
    end;
m_find_value(_V, #m{value=numtest}, _Context) -> 
    ["M_numtest", _V];
m_find_value(_V, #m{value=modtest}, _Context) -> 
    ["M_modtest", _V];
m_find_value(_V, #m{value=undefined}, _Context) -> 
    ["M_Undefined", _V];
m_find_value(_V, _VV, _Context) -> 
    [_V,_VV,"m_zonnet_find_value_mismatch"].

m_to_list(_V, _Context) ->
    [_V,"m_to_list"].

m_value(#m{value=V}, _Context) -> V.
