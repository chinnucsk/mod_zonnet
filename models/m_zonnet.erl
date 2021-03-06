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
    zonnet_util:accounts_table(Fields, Limit, Context);

m_find_value({accounts_addr_table,[{type,Type}]}, _M, Context) -> 
    zonnet_util:accounts_addr_table(Type, Context);

m_find_value(agreements_table, _M, Context) -> 
    zonnet_util:agreements_table(Context);

m_find_value(account_balance, _M, Context) -> 
    zonnet_util:account_balance(Context);

m_find_value(account_payments, _M, Context) -> 
    zonnet_util:account_payments(1000, Context);
m_find_value({account_payments,[{limit,Limit}]}, _M, Context) -> 
    zonnet_util:account_payments(Limit, Context);

m_find_value(credit_info, _M, Context) -> 
    zonnet_util:credit_info(Context);

m_find_value(credit_able, _M, Context) -> 
    zonnet_util:credit_able(Context);

m_find_value(credit_allowed, _M, Context) -> 
    zonnet_util:credit_allowed(Context);

m_find_value(acount_status, _M, Context) -> 
    zonnet_util:acount_status(Context);

m_find_value({is_service_provided,[{type,Type}]}, _M, Context) -> 
    zonnet_util:is_service_provided(Type, Context);

m_find_value(monthly_fees, _M, Context) -> 
    zonnet_util:monthly_fees(Context);

m_find_value(user_type, _M, Context) -> 
    zonnet_util:user_type(Context);

m_find_value({accounts_tariffs_by_type,[{type,Type}]}, _M, Context) -> 
    zonnet_util:accounts_tariffs_by_type(Type, Context);

m_find_value({tariff_descr_by_tar_id,[{tar_id,Tar_id}]}, _M, Context) -> 
    zonnet_util:tariff_descr_by_tar_id(Tar_id, Context);

m_find_value({numbers_by_vg_id,[{vg_id,Vg_id}]}, _M, Context) -> 
    zonnet_util:numbers_by_vg_id(Vg_id, Context);

m_find_value({ip_addresses_by_vg_id,[{vg_id,Vg_id}]}, _M, Context) -> 
    zonnet_util:ip_addresses_by_vg_id(Vg_id, Context);

m_find_value(is_prepaid, _M, Context) -> 
    zonnet_util:is_prepaid(Context);

m_find_value(calc_curr_month_exp, _M, Context) -> 
    zonnet_util:calc_curr_month_exp(Context);

m_find_value(get_accounts_emails, _M, Context) -> 
    zonnet_util:get_accounts_emails(Context);

m_find_value(get_calls_list, _M, Context) -> 
    {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
    zonnet_util:get_calls_list_by_period({from, Year, Month, Day},{till, Year, Month, Day},{callsdirection,"0,1"},{callstype,"1,6"},{limit,"3000"},Context);

m_find_value({get_docs_list,[{docsids, DocsIds},{month, MonthInput}]}, _M, Context) -> 
  if
     MonthInput =/= undefined ->
         [Month, Year] = string:tokens(MonthInput,"/"),
         zonnet_util:get_docs_list({date, Year, Month},{docsids, DocsIds}, Context);
     true ->
         case zonnet_util:is_prepaid(Context) of 
            [] -> 
                 {{Year, Month, _}, {_, _, _}} = erlang:localtime(),
                 zonnet_util:get_docs_list({date, integer_to_list(Year), integer_to_list(Month-1)},{docsids, DocsIds}, Context);
            _  ->
                 case re:run(DocsIds,"3[4,5]") of
                     nomatch ->
                       {{Year, Month, _}, {_, _, _}} = z_datetime:prev_month(erlang:localtime()),
                       zonnet_util:get_docs_list({date, integer_to_list(Year), integer_to_list(Month)},{docsids, DocsIds}, Context);
                     _ ->
                       {{Year, Month, _}, {_, _, _}} = erlang:localtime(),
                       zonnet_util:get_docs_list({date, integer_to_list(Year), integer_to_list(Month)},{docsids, DocsIds}, Context)
                 end
         end
  end; 
m_find_value(get_docs_list, _M, Context) -> 
    {{Year, Month, _}, {_, _, _}} = erlang:localtime(),
    zonnet_util:get_docs_list({date, integer_to_list(Year), integer_to_list(Month-1)},{docsids, "1,2,3,34,35"}, Context);

m_find_value(calc_fees_by_period, _M, Context) -> 
    {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
    zonnet_util:calc_fees_by_period({from, Year, Month, Day},{till, Year, Month, Day},Context);
m_find_value({calc_fees_by_period,[{month,MonthInput},{from,StartDayInput},{till,EndDayInput}]}, _M, Context) -> 
  if 
     MonthInput =/= undefined -> 
         [MonthM, YearM] = string:tokens(MonthInput,"/"),
         zonnet_util:calc_fees_by_period({from, list_to_integer(YearM), list_to_integer(MonthM), 1},{till, list_to_integer(YearM), list_to_integer(MonthM), calendar:last_day_of_the_month(list_to_integer(YearM), list_to_integer(MonthM))},Context);
     EndDayInput =/= undefined -> 
         [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
         [DayE, MonthE, YearE] = string:tokens(EndDayInput,"/"),
         zonnet_util:calc_fees_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearE), list_to_integer(MonthE), list_to_integer(DayE)},Context);
     StartDayInput =/= undefined -> 
         [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
         zonnet_util:calc_fees_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},Context);
     true -> 
      {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
      zonnet_util:calc_fees_by_period({from, Year, Month, Day},{till, Year, Month, Day},Context)
  end;

m_find_value(calc_traffic_costs_by_period, _M, Context) -> 
    {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
    zonnet_util:calc_traffic_costs_by_period({from, Year, Month, Day},{till, Year, Month, Day},Context);
m_find_value({calc_traffic_costs_by_period,[{month,MonthInput},{from,StartDayInput},{till,EndDayInput}]}, _M, Context) -> 
  if 
     MonthInput =/= undefined -> 
         [MonthM, YearM] = string:tokens(MonthInput,"/"),
         zonnet_util:calc_traffic_costs_by_period({from, list_to_integer(YearM), list_to_integer(MonthM), 1},{till, list_to_integer(YearM), list_to_integer(MonthM), calendar:last_day_of_the_month(list_to_integer(YearM), list_to_integer(MonthM))},Context);
     EndDayInput =/= undefined -> 
         [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
         [DayE, MonthE, YearE] = string:tokens(EndDayInput,"/"),
         zonnet_util:calc_traffic_costs_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearE), list_to_integer(MonthE), list_to_integer(DayE)},Context);
     StartDayInput =/= undefined -> 
         [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
         zonnet_util:calc_traffic_costs_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},Context);
     true -> 
      {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
      zonnet_util:calc_traffic_costs_by_period({from, Year, Month, Day},{till, Year, Month, Day},Context)
  end;

m_find_value({format_address,[{addrtype, AddrType}]}, _M, Context) -> 
    zonnet_util:format_address(AddrType, Context);

m_find_value(_V, _VV, _Context) -> 
    [_V,_VV,"m_zonnet_find_value_mismatch"].

m_to_list(_V, _Context) ->
    [_V,"m_to_list"].

m_value(#m{value=V}, _Context) -> V.
