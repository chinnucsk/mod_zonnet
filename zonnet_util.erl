-module(zonnet_util).
-author("Kirill Sysoev <kirill.sysoev@gmail.com>").

%% interface functions
-export([
        is_numeric/1,
        get_uid/1,
        get_main_agrm_id/1,
        credit_allowed/1,
        credit_able/1,
        credit_info/1,
        account_payments/2,
        account_balance/1,
        agreements_table/1,
        accounts_addr_table/2,
        accounts_table/3,
        acount_status/1,
        is_service_provided/2,
        monthly_fees/1,
        user_type/1,
        accounts_tariffs_by_type/2,
        tariff_descr_by_tar_id/2,
        numbers_by_vg_id/2,
        ip_addresses_by_vg_id/2,
        is_prepaid/1,
        calc_curr_month_exp/1,
        get_calls_list/1
]).

-include_lib("zotonic.hrl").

is_numeric(L) ->
    Float = (catch erlang:list_to_float(L)),
    Int = (catch erlang:list_to_integer(L)),
    is_number(Float) orelse is_number(Int).

get_uid(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            [[QueryResult]] = z_mydb:q(<<"select uid from accounts where login = ? limit 1">>,[Z_User], Context),
            mochinum:digits(QueryResult)
    end.

get_main_agrm_id(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            [[QueryResult]] = z_mydb:q(<<"SELECT agrm_id from agreements where uid  = (select uid from accounts where login = ? limit 1) and oper_id = 1">>,[Z_User], Context),
            mochinum:digits(QueryResult)
    end.

credit_allowed(Context) ->
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
    end.

credit_able(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q(<<"select group_id from usergroups_staff where uid = (select uid from accounts
                                   where login = ? limit 1) and group_id = 10">>,[Z_User], Context) of
                [[10]] -> true;
                   _   -> false
            end
    end.

credit_info(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q(<<"select agrm_id,amount,prom_date,prom_till,debt,pay_id from promise_payments where debt != 0 and agrm_id = (select agrm_id from agreements where oper_id = 1 and archive =0 and uid = (select uid from accounts where login = ? limit 1)) limit 1">>,[Z_User], Context) of
                [[Agrm_id,Amount,Prom_date,Prom_till,Debt,Pay_id]] -> [[Agrm_id,Amount,Prom_date,Prom_till,Debt,Pay_id]];
                   _   -> []
            end
    end.

account_payments(Limit, Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryResult = z_mydb:q(<<"SELECT amount, left(pay_date,10), if(comment like '%assist%','Система Ассист',
                'Безналичный платеж') as comment FROM payments where agrm_id = (SELECT agrm_id from agreements
                 where uid  = (select uid from accounts where login = ? limit 1) and oper_id = 1)
                ORDER BY LEFT( pay_date, 10 ) DESC limit ?">>,[Z_User,Limit], Context),
            QueryResult
    end.

account_balance(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("SELECT FORMAT(COALESCE(sum(balance),0),2) FROM agreements  where uid = (select uid from accounts where login = \'~s\' limit 1) and agreements.archive = 0",[Z_User])),
            [QueryResult] = z_mydb:q(QueryString, Context),
            QueryResult
    end.

agreements_table(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("SELECT agreements.number, agreements.date, accounts.name FROM agreements, accounts where accounts.uid=agreements.oper_id and agreements.uid = (select uid from accounts where login = \'~s\' limit 1) and agreements.archive = 0",[Z_User])),
            QueryResult = z_mydb:q(QueryString, Context),
            QueryResult
    end.

accounts_addr_table(Type, Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("select address from accounts_addr where uid = (select uid from accounts where login = \'~s\' limit 1) and type = ~p limit 1",[Z_User,Type])),
            [QueryResult] = z_mydb:q(QueryString, Context),
            QueryResult
    end.

accounts_table(Fields, Limit, Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("select ~s from accounts where login = \'~s\' limit ~p",[list_to_atom(Fields),Z_User,Limit])),
            [QueryResult] = z_mydb:q(QueryString, Context),
            QueryResult
    end.

acount_status(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q(<<"SELECT blocked FROM vgroups where uid = (select uid from accounts where login = ? limit 1) 
                                                                              and archive = 0 and id = 1">>,[Z_User], Context) of
                [[StatusID]] -> StatusID;
                 _  -> 
                    case z_mydb:q(<<"SELECT blocked FROM vgroups where uid = (select uid from accounts where login = ? limit 1) 
                                                           and archive = 0 order by blocked desc limit 1">>,[Z_User], Context) of
                       [[StatusID]] -> StatusID;
                       _ -> []
                    end
            end
    end.

is_service_provided(Type, Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q("SELECT type from tarifs where tar_id in (SELECT tar_id FROM vgroups where agrm_id = 
                                      (SELECT agrm_id FROM agreements where uid = (select uid from accounts where login = 
                                                                ? limit 1) and oper_id = 1)) and type=?", [Z_User,Type], Context) of
                [] -> 0;
                _  -> 1
            end
    end.

monthly_fees(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->

            QueryResult = z_mydb:q("SELECT SUBSTRING(descr,8), ROUND(above,0), mul, above*mul as amount from usbox_services, categories  where usbox_services.cat_idx = categories.cat_idx and usbox_services.tar_id = categories.tar_id and vg_id in (SELECT vg_id FROM vgroups where agrm_id = (SELECT agrm_id FROM `agreements` where uid = (select uid from accounts where login = ? limit 1) and oper_id = 1)) and oper_id = 1",[Z_User], Context),



%            QueryResult = z_mydb:q("SELECT SUBSTRING(categories.descr,7), categories.above from categories,usbox_services,vgroups 
%                                     where categories.tar_id = vgroups.tar_id and usbox_services.vg_id = vgroups.vg_id and 
%                                     categories.cat_idx = usbox_services.cat_idx and vgroups.uid = (select uid from accounts 
%                                     where login = ? limit 1) and categories.common = 3  and usbox_services.timeto > NOW()",
%                                                                                                                 [Z_User], Context),
            QueryResult
    end.

%% If user acting as company or as an individual
user_type(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            [QueryResult] = z_mydb:q("select type from accounts where login = ? limit 1",[Z_User], Context),
            QueryResult
    end.

accounts_tariffs_by_type(Type, Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q("select vg_id,tar_id from vgroups where uid = (select uid from accounts where login = ? limit 1) 
                                                                                              and id = ?", [Z_User,Type], Context) of
                [] -> [];
                QueryResult  -> QueryResult
            end
    end.

tariff_descr_by_tar_id(Tar_id, Context) ->
     case z_mydb:q("select descr from tarifs where tar_id = ? limit 1", [Tar_id], Context) of
          [] -> [];
          QueryResult  -> QueryResult
     end.

numbers_by_vg_id(Vg_id, Context) ->
     case z_mydb:q("SELECT if(substring(phone_number,8)='',CONCAT('(812) ', phone_number), if(substring(phone_number,11)='', CONCAT('(',MID(phone_number,1,3),') ', right(phone_number,7)),CONCAT('(',MID(phone_number,2,3),') ',RIGHT(phone_number,7)))) from tel_staff where vg_id = ?", [Vg_id], Context) of
          [] -> [];
          QueryResult  -> QueryResult
     end.

ip_addresses_by_vg_id(Vg_id, Context) ->
     case z_mydb:q("SELECT concat(INET_NTOA(segment),' / ',INET_NTOA(mask)) FROM staff where vg_id = ?", [Vg_id], Context) of
          [] -> [];
          QueryResult  -> QueryResult
     end.

%% check whether user has prepaid agreement
is_prepaid(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q("SELECT 1 FROM tarifs, vgroups where tarifs.tar_id = vgroups.tar_id and vgroups.uid = 
                                          (select uid from accounts where login = ? limit 1) and tarifs.type = 5 
                                                                               and tarifs.act_block > 0",[Z_User], Context) of
                [QueryResult] -> QueryResult;
                _ -> []
            end
    end.

%% calculate current month expenditures FORMAT(COALESCE(sum(balance),0),2)
calc_curr_month_exp(Context) ->
    case get_uid(Context) of
        [] -> ["0"];
        Uid -> 
          {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
          Today = io_lib:format("~w~2..0w~2..0w",[Year, Month, Day]),
%          CurrMonth = io_lib:format("~w~2..0w",[Year, Month]),
          case Day of
           1 -> 
             QueryString = io_lib:format("Select FORMAT(COALESCE( 
                if((SELECT sum(amount) FROM  tel001~s where uid = ~s)>0,(SELECT sum(amount) FROM  tel001~s where uid = ~s),0) + 
                if((SELECT sum(amount) FROM  user002~s where uid = ~s)>0,(SELECT sum(amount) FROM  user002~s where uid = ~s),0),0),2) 
                                              ",[Today,Uid,Today,Uid,Today,Uid,Today,Uid]);
           _ ->
             QueryString = io_lib:format("Select FORMAT(COALESCE( 
                if((SELECT sum(amount) FROM  tel001~s where uid = ~s)>0,(SELECT sum(amount) FROM  tel001~s where uid = ~s),0) + 
                if((SELECT sum(amount) FROM  user002~s where uid = ~s)>0,(SELECT sum(amount) FROM  user002~s where uid = ~s),0),0),2) 
                                              ",[Today,Uid,Today,Uid,Today,Uid,Today,Uid])
%            QueryString = io_lib:format("Select FORMAT(COALESCE(Sum(amount) + 
%              if((SELECT sum(amount) FROM  tel001~s where uid = ~s)>0,(SELECT sum(amount) FROM  tel001~s where uid = ~s),0) + 
%              if((SELECT sum(amount) FROM  user002~s where uid = ~s)>0,(SELECT sum(amount) FROM  user002~s where uid = ~s),0),0),2) 
%                                              from report~s where uid = ~s",[Today,Uid,Today,Uid,Today,Uid,Today,Uid,CurrMonth,Uid])
          end,
          case z_mydb:q(QueryString, Context) of
               [[undefined]] -> ["0"];
               [QueryResult] -> QueryResult;
               _ -> ["0"]
          end
    end.

%% check whether user has prepaid agreement
get_calls_list(Context) ->
    case get_uid(Context) of
      [] -> [];
      Uid -> 
         z_mydb:q("select timefrom, numfrom, numto, format(duration_round/60, 0), direction, format(amount, 2) from tel00120130531 where uid =  ?",
                                                                                                                 [Uid], Context)
    end.
