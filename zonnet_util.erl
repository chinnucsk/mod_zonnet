-module(zonnet_util).
-author("Kirill Sysoev <kirill.sysoev@gmail.com>").

%% interface functions
-export([
        is_numeric/1
        ,get_uid/1
        ,get_next_doc_number/2
        ,get_last_order_id/2
        ,get_main_agrm_id/1
        ,credit_allowed/1
        ,credit_able/1
        ,credit_info/1
        ,account_payments/2
        ,account_balance/1
        ,agreements_table/1
        ,accounts_addr_table/2
        ,get_accounts_emails/1
        ,accounts_table/3
        ,acount_status/1
        ,is_service_provided/2
        ,monthly_fees/1
        ,user_type/1
        ,accounts_tariffs_by_type/2
        ,tariff_descr_by_tar_id/2
        ,numbers_by_vg_id/2
        ,ip_addresses_by_vg_id/2
        ,is_prepaid/1
        ,is_valid_account/1
        ,is_valid_account/2
        ,calc_curr_month_exp/1
        ,calc_traffic_costs_by_period/3
        ,calc_fees_by_period/3
        ,get_calls_list_by_day/5
        ,amount_of_days_in_period/2
        ,next_day/1
        ,count_day/2
        ,countdown_day/2
        ,day_to_string/1
        ,collect_calls/7
        ,collect_calls/8
        ,get_calls_list_by_period/6
        ,get_docs_list/3
        ,get_fullpath_by_order_id/2
        ,get_address_ids_by_type/2
        ,format_address/2
        ,get_address_element/4
        ,calls_list_query/7
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
            case z_mydb:q(<<"select uid from accounts where login = ? limit 1">>,[Z_User], Context) of
                [[QueryResult]] -> mochinum:digits(QueryResult);
                _ -> []
            end
    end.

get_next_doc_number(Doc_Id, Context) ->
    case z_mydb:q(<<"select max(cast(order_num as unsigned))+1 as order_num from orders where doc_id = ?">>,[Doc_Id], Context) of
        [[QueryResult]] -> mochinum:digits(QueryResult);
        _ -> []
    end.

get_last_order_id(Doc_Id, Context) ->
    case get_uid(Context) of
        [] -> [];
        Uid ->
            case z_mydb:q(<<"select max(order_id) as order_num from orders where doc_id = ? and agrm_id in (Select agrm_id from agreements where uid = ?)">>,[Doc_Id, Uid], Context) of
                [[QueryResult]] -> mochinum:digits(QueryResult);
                _ -> []
            end
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
            case z_mydb:q(QueryString, Context) of
                [QueryResult] -> QueryResult;
                _ -> []
            end
    end.

get_accounts_emails(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q("select email from accounts where login = ? limit 1", [Z_User], Context) of
                [[QueryResult]] ->  binary:split(QueryResult, [<<",">>,<<";">>], [global]);
                _ -> []
            end
    end.

accounts_table(Fields, Limit, Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("select ~s from accounts where login = \'~s\' limit ~p",[list_to_atom(Fields),Z_User,Limit])),
            case z_mydb:q(QueryString, Context) of
                [QueryResult] -> QueryResult;
                _ -> []
            end
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
            QueryResult = z_mydb:q("SELECT SUBSTRING(categories.descr,7), ROUND(categories.above,0), mul, above*mul from categories,usbox_services,vgroups where categories.tar_id = vgroups.tar_id and usbox_services.vg_id = vgroups.vg_id and categories.cat_idx = usbox_services.cat_idx and vgroups.uid = (select uid from accounts where login = ? limit 1) and categories.common in (1,3) and usbox_services.timeto > NOW()",[Z_User], Context),
            QueryResult
    end.

%% If user acting as company or as an individual
user_type(Context) ->
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            case z_mydb:q("select type from accounts where login = ? limit 1",[Z_User], Context) of
                [QueryResult] -> QueryResult;
                _ -> []
            end
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
                                                  and tarifs.act_block > 0  and vgroups.blocked < 10 limit 1",[Z_User], Context) of
                [QueryResult] -> QueryResult;
                _ -> []
            end
    end.
%%

%% check whether account is valid
is_valid_account(Context) ->
    case m_identity:get_username(Context) of
        undefined -> false;
        Z_User ->
            case z_mydb:q("select 1 from vgroups where uid = (select uid from accounts where login = ? limit 1) and blocked < 10 limit 1",[Z_User], Context) of
                [[1]] -> true;
                _ -> 
                       case z_mydb:q("SELECT 1 FROM agreements where uid = (select uid from accounts where login = ? limit 1) and oper_id = 1 and date between date_sub(now(), interval 1 month) and now()",[Z_User], Context) of
                            [[1]] -> true;
                            _ -> false
                       end
            end
    end.
%%
is_valid_account(UserId, Context) ->
    case m_identity:get_username(UserId, Context) of
        undefined -> false;
        Z_User ->
            case z_mydb:q("select 1 from vgroups where uid = (select uid from accounts where login = ? limit 1) and blocked < 10 limit 1",[Z_User], Context) of
                [[1]] -> true;
                _ -> 
                       case z_mydb:q("SELECT 1 FROM agreements where uid = (select uid from accounts where login = ? limit 1) and oper_id = 1 and date between date_sub(now(), interval 1 month) and now()",[Z_User], Context) of
                            [[1]] -> true;
                            _ -> false
                       end
            end
    end.
%%
%% calculate current month expenditures FORMAT(COALESCE(sum(balance),0),2)
%%
calc_curr_month_exp(Context) ->
    case get_uid(Context) of
        [] -> ["0"];
        Uid -> 
          {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
          Today = io_lib:format("~w~2..0w~2..0w",[Year, Month, Day]),
          QueryString = io_lib:format("Select FORMAT(COALESCE(ifnull((SELECT sum(amount) FROM  tel001~s where uid = ~s),0) + ifnull((SELECT sum(amount) FROM  user002~s where uid = ~s),0) + ifnull((SELECT sum(amount) FROM  day where Month(timefrom) = Month(Now()) and Year(timefrom) = Year(Now()) and uid = ~s),0) + (Select sum(amount) from usbox_charge where agrm_id = (SELECT agrm_id FROM agreements where uid = ~s and oper_id = 1) and Month(period) = Month(Now()) and Year(period) = Year(Now())),0),2)",[Today,Uid,Today,Uid,Uid,Uid]),
          case z_mydb:q(QueryString, Context) of
               [[undefined]] -> ["0"];
               [QueryResult] -> QueryResult;
               _ -> ["0"]
          end
    end.
%% 

%% calculate traffic expenses for particular period 
calc_fees_by_period({from, YearFrom, MonthFrom, DayFrom},{till, YearTill, MonthTill, DayTill}, Context) ->
    case get_uid(Context) of
        [] -> ["0"];
        Uid -> 
          QueryString = io_lib:format("SELECT FORMAT(COALESCE(sum(amount),0),2) FROM usbox_charge where agrm_id = (SELECT agrm_id FROM agreements where uid = ~s and oper_id = 1) and period between \'~w-~2..0w-~2..0w\' and \'~w-~2..0w-~2..0w\'",[Uid, YearFrom, MonthFrom, DayFrom, YearTill, MonthTill, DayTill]),
          case z_mydb:q(QueryString, Context) of
               [[undefined]] -> ["0"];
               [QueryResult] -> QueryResult;
               _ -> ["0"]
          end
    end.

%% calculate traffic expenses for particular period 
calc_traffic_costs_by_period({from, YearFrom, MonthFrom, DayFrom},{till, YearTill, MonthTill, DayTill}, Context) ->
    case get_uid(Context) of
        [] -> ["0"];
        Uid -> 
          {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
          Today = io_lib:format("~w~2..0w~2..0w",[Year, Month, Day]),
          LastDay = io_lib:format("~w~2..0w~2..0w",[YearTill, MonthTill, DayTill]),
          case string:equal(Today,LastDay) of
              true ->
                  QueryString = io_lib:format("SELECT FORMAT(COALESCE((select ifnull(sum(amount),0) FROM  day where uid = ~s and timefrom between \'~w-~2..0w-~2..0w\' and \'~w-~2..0w-~2..0w\') + (SELECT ifnull(sum(amount),0) FROM  tel001~s where uid = ~s) + (SELECT ifnull(sum(amount),0) FROM  user002~s where uid = ~s),0),2)",[Uid, YearFrom, MonthFrom, DayFrom, YearTill, MonthTill, DayTill, Today, Uid, Today, Uid]);
              _ -> 
                  QueryString = io_lib:format("SELECT FORMAT(COALESCE(sum(amount),0),2) FROM  day where uid = ~s and timefrom between \'~w-~2..0w-~2..0w\' and \'~w-~2..0w-~2..0w\'",[Uid, YearFrom, MonthFrom, DayFrom, YearTill, MonthTill, DayTill])
          end,
          case z_mydb:q(QueryString, Context) of
               [[undefined]] -> ["0"];
               [QueryResult] -> QueryResult;
               _ -> ["0"]
          end
    end.
%% 
%%
get_calls_list_by_day({Year, Month, Day},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context) ->
    case get_uid(Context) of
      [] -> [];
      Uid -> 
         QueryString = io_lib:format("select timefrom, numfrom, numto, format(duration_round/60, 0), direction, format(amount, 2) from tel001~w~2..0w~2..0w where uid =  ~s and direction in (~s) and oper_id in (~s) order by timefrom desc limit ~s", [Year, Month, Day, Uid, Direction, CallsType, MaxCalls]),
         z_mydb:q(QueryString, Context)
    end.
%
%
amount_of_days_in_period({from, YearFrom, MonthFrom, DayFrom},{till, YearTill, MonthTill, DayTill}) ->
    case calendar:date_to_gregorian_days(YearTill, MonthTill, DayTill) - calendar:date_to_gregorian_days(YearFrom, MonthFrom, DayFrom) of 
        N when N >= 0 -> N;
        _ -> 0
    end.
%
%
next_day({Year,Month,Day}) ->
    calendar:gregorian_days_to_date(calendar:date_to_gregorian_days({Year, Month, Day}) + 1).
%
%
count_day({Year,Month,Day},N) ->
    calendar:gregorian_days_to_date(calendar:date_to_gregorian_days({Year, Month, Day}) + N).
%
%
countdown_day({Year,Month,Day},N) ->
    calendar:gregorian_days_to_date(calendar:date_to_gregorian_days({Year, Month, Day}) - N).
%
%
day_to_string({Year,Month,Day}) ->
    lists:flatten(io_lib:format("~w~2..0w~2..0w",[Year, Month, Day])).
%
%
get_calls_list_by_period({from, YearFrom, MonthFrom, DayFrom},{till, YearTill, MonthTill, DayTill},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context) ->
    DaysAmount = amount_of_days_in_period({from, YearFrom, MonthFrom, DayFrom},{till, YearTill, MonthTill, DayTill}),
    collect_calls(startdate, {YearFrom, MonthFrom, DayFrom},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context, DaysAmount).
%
%
collect_calls(startdate, {Year, Month, Day},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context,N) ->
    collect_calls(startdate, {Year, Month, Day},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context, N, []).
collect_calls(startdate, {Year, Month, Day},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context, N, Acc) ->
    if 
       N < 0 ->
           Acc;
       N >= 0 ->
           AccNew = Acc ++ get_calls_list_by_day(count_day({Year, Month, Day},N),{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context),
           collect_calls(startdate, {Year, Month, Day},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context, N-1, AccNew) 
    end.

get_docs_list({date, Year, Month},{docsids, DocsIds}, Context) ->
    case get_uid(Context) of
        [] -> ["0"];
        Uid -> 
            QueryString = io_lib:format("SELECT accounts.name, orders.order_id, orders.order_num, orders.order_date, orders.curr_summ, round(orders.tax_summ,2), round(orders.curr_summ + round(orders.tax_summ,2),2)  FROM orders, accounts where accounts.uid=orders.oper_id and Year(period) = ~s and Month(period) = ~s and agrm_id in (Select agrm_id from agreements where uid = ~s) and doc_id in (~s)", [Year, Month, Uid, DocsIds]),
            z_mydb:q(QueryString, Context)
    end.

get_fullpath_by_order_id(Order_Id, Context) ->
    case get_uid(Context) of
        [] -> [];
        Uid -> 
            QueryString = io_lib:format("SELECT replace(file_name,'./','/usr/local/billing/') FROM orders where order_id = ~p and agrm_id in (Select agrm_id from agreements where uid = ~s) limit 1", [Order_Id, Uid]),
          case z_mydb:q(QueryString, Context) of
              [] -> [];
              [QueryResult] -> QueryResult
          end
    end.

get_address_ids_by_type(AddrType,Context) ->
    case get_uid(Context) of
        [] -> [];
        Uid ->
            case z_mydb:q("select aa.country, aa.region, aa.area, aa.city, aa.settl, aa.street, aa.building, aa.flat, aa.entrance, aa.floor  from agreements ag, accounts a left join accounts_addr aa on a.uid=aa.uid where ag.agrm_id=(SELECT agrm_id FROM agreements where uid = ? and oper_id = 1) and a.uid=ag.uid and aa.type=?",[Uid, AddrType], Context) of
                [QueryResult] -> QueryResult;
                _ -> []
            end
    end.

format_address(AddrType,Context) ->
    case get_address_ids_by_type(AddrType, Context) of
        [] -> [];
        [CountryId, RegionId, AreaId, CityId, SettlId, StreetId, BuildingId, FlatId, EntranceId, FloorId] ->
           Country = get_address_element("name", "country", CountryId, Context),
           Region = get_address_element("short", "region", RegionId, Context) ++ " " ++ get_address_element("name", "region", RegionId, Context),
           if RegionId == 80; RegionId == 86; RegionId == 0; RegionId == undefined ->
                Address1 = list_to_binary([Country]);
              true ->
                Address1 = list_to_binary([Country, ", ", Region])
           end,
           if AreaId == 0; AreaId == undefined ->
                Address2 = Address1;
              true ->
                Address2 = list_to_binary([Address1, ", ", get_address_element("short", "area", AreaId, Context), " ",get_address_element("name", "area", AreaId, Context)])
           end,
           if CityId == 0; CityId == undefined ->
                Address3 = Address2;
              true ->
                Address3 = list_to_binary([Address2, ", ", get_address_element("short", "city", CityId, Context), " ",get_address_element("name", "city", CityId, Context)])
           end,
           if SettlId == 0; SettlId == undefined ->
                Address4 = Address3;
              true ->
                Address4 = list_to_binary([Address3, ", ", get_address_element("short", "settl", SettlId, Context), " ",get_address_element("name", "settl", SettlId, Context)])
           end,
           if StreetId == 0; StreetId == undefined ->
                Address5 = Address4;
              true ->
                Address5 = list_to_binary([Address4, ", ", get_address_element("short", "street", StreetId, Context), " ",get_address_element("name", "street", StreetId, Context)])
           end,
           if BuildingId == 0; BuildingId == undefined ->
                Address6 = Address5;
              true ->
                Address6 = list_to_binary([Address5, ", ", get_address_element("short", "building", BuildingId, Context), " ",get_address_element("name", "building", BuildingId, Context)])
           end,
           if FlatId == 0; FlatId == undefined ->
                Address7 = Address6;
              true ->
                Address7 = list_to_binary([Address6, ", ", get_address_element("short", "flat", FlatId, Context), " ",get_address_element("name", "flat", FlatId, Context)])
           end,
           if EntranceId == 0; EntranceId == undefined ->
                Address8 = Address7;
              true ->
                Address8 = list_to_binary([Address7, ", ", get_address_element("short", "entrance", EntranceId, Context), " ",get_address_element("name", "entrance", EntranceId, Context)])
           end,
           if FloorId == 0; FloorId == undefined ->
                Address9 = Address8;
              true ->
                Address9 = list_to_binary([Address8, ", ", get_address_element("short", "floor", FloorId, Context), " ",get_address_element("name", "floor", FloorId, Context)])
           end,
           if BuildingId /= 0, BuildingId /= undefined ->
                Address10 = list_to_binary([get_address_element("idx", "building", BuildingId, Context), ", ", Address9]);
              StreetId /= 0, StreetId /= undefined ->
                Address10 = list_to_binary([get_address_element("idx", "street", StreetId, Context), ", ", Address9]);
              true ->
                Address10 = Address9
           end,
           Address10
    end.

get_address_element(Field, ElementName, RecordId, Context) ->
    QueryString = io_lib:format("select cast\(~s\ as char) from address_~s where record_id = ~p", [Field, ElementName, RecordId]),
    case z_mydb:q(QueryString, Context) of
        [] -> [];
        [QueryResult] -> QueryResult
    end.

calls_list_query({callsdirection,Direction},{callstype,CallsType},{from,StartDayInput},{limit,MaxCalls},{month,MonthInput},{till,EndDayInput}, Context) ->
    if
        MonthInput =/= undefined, MonthInput =/= "undefined" ->
            case re:run(MonthInput, "^\\d{2}\\/\\d{4}$", [{capture, none}]) of
                match ->
                    get_month_calls(MonthInput, Direction, CallsType, MaxCalls, Context);
                _ -> badmonth
            end;
        EndDayInput =/= undefined, EndDayInput =/= "undefined" ->     
            case re:run(EndDayInput, "^\\d{2}\\/\\d{2}\\/\\d{4}$", [{capture, none}]) of
                match ->
                    get_period_calls(StartDayInput, EndDayInput, Direction, CallsType, MaxCalls, Context);
                _ -> badendday
            end;
        StartDayInput =/= undefined, StartDayInput =/= "undefined" ->
            case re:run(StartDayInput, "^\\d{2}\\/\\d{2}\\/\\d{4}$", [{capture, none}]) of
                match ->
                    get_day_calls(StartDayInput, Direction, CallsType, MaxCalls, Context);
                _ -> badstartday
            end;
        true ->
            {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
            zonnet_util:get_calls_list_by_period({from, Year, Month, Day},{till, Year, Month, Day},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context)
    end.

get_month_calls(MonthInput, Direction, CallsType, MaxCalls, Context) ->
    [MonthM, YearM] = string:tokens(MonthInput,"/"),
    zonnet_util:get_calls_list_by_period({from, list_to_integer(YearM), list_to_integer(MonthM), 1},{till, list_to_integer(YearM), list_to_integer(MonthM), calendar:last_day_of_the_month(list_to_integer(YearM), list_to_integer(MonthM))},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context).

get_period_calls(StartDayInput, EndDayInput, Direction, CallsType, MaxCalls, Context) ->
                    [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
                    [DayE, MonthE, YearE] = string:tokens(EndDayInput,"/"),
                    zonnet_util:get_calls_list_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearE), list_to_integer(MonthE), list_to_integer(DayE)},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context).

get_day_calls(StartDayInput, Direction, CallsType, MaxCalls, Context) ->
    [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
    zonnet_util:get_calls_list_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context).


