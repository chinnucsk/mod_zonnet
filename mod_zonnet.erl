%% @author Kirill Sysoev <kirill.sysoev@gmail.com>
%% @date 2013-04-27%
%% @doc OnNet communications/innovations customer support module. 

-module(mod_zonnet).
-author("Kirill Sysoev <kirill.sysoev@gmail.com>").
-mod_title("Z OnNet").
-mod_description("OnNet communications innovations customer support module.").
-mod_prio(400).

-export([
    get_account_data/1,
    observe_zonnet_menu/3,
    observe_foo/2,
    observe_postback_notify/2,
    observe_search_query/2,
    event/2
]).

-include_lib("zotonic.hrl").
%%-include_lib("include/zotonic_notifications.hrl").
-include_lib("include/zonnet_menu.hrl").

-record(account_details, {uid, name, phone, fax, email, bank_name, gen_dir_u, kont_person}).

get_account_data(Context) ->
    Username = m_identity:get_username(Context),
    LBAccResult = z_mydb:q_raw(<<"select uid, name, phone, fax, email, bank_name, gen_dir_u, kont_person 
                                          from accounts where login = ? limit 1">>, [Username], Context),
    RecAccs = emysql_util:as_record(LBAccResult, account_details, record_info(fields, account_details)),

    case RecAccs of
        [] ->
            undefined;
        [RecAcc] ->
            LB_company_name = {company_name, RecAcc#account_details.name},
            LB_phone = {phone, RecAcc#account_details.phone},
            LB_fax = {fax, RecAcc#account_details.fax},
            LB_email = {email, RecAcc#account_details.email},
            LB_bank_name = {bank_name, RecAcc#account_details.bank_name},
            LB_gen_dir = {gen_dir_u, RecAcc#account_details.gen_dir_u},
            LB_kont_person = {kont_person, RecAcc#account_details.kont_person},
            CompanyAddr = z_mydb:q(<<"select address from accounts_addr where uid = ? and type = ? limit 1">>,
                                                                     [RecAcc#account_details.uid, 0], Context),
            LB_CompanyAddr = {company_addr, CompanyAddr},
            MailAddr = z_mydb:q(<<"select address from accounts_addr where uid = ? and type = ? limit 1">>,
                                                                  [RecAcc#account_details.uid, 2], Context),
            LB_MailAddr = {mail_addr, MailAddr},
            [[ACCBalance]] = z_mydb:q(<<"SELECT FORMAT(COALESCE(sum(balance),0),2) FROM agreements  where uid = ?">>,
                                                                               [RecAcc#account_details.uid], Context),
            LB_ACCBalance = {accbalance, ACCBalance},

            Agreements = z_mydb:q(<<"SELECT agreements.number, agreements.date, accounts.name FROM agreements, accounts
                                 where accounts.uid=agreements.oper_id and agreements.uid = ? and agreements.archive = 0">>,
                                                                                     [RecAcc#account_details.uid], Context),
            LB_Agreements = {agreements, Agreements},

            AccPayments = z_mydb:q(<<"SELECT amount, left(pay_date,10), if(comment like '%assist%','Система Ассист',
                'Безналичный платеж') as comment FROM payments 
                where agrm_id = (SELECT agrm_id from agreements where uid  = ? and oper_id = 1) 
                ORDER BY LEFT( pay_date, 10 ) DESC">>,
                                                                                     [RecAcc#account_details.uid], Context),
            LB_AccPayments = {payments, AccPayments},

            AccServices = z_mydb:q(<<"SELECT SUBSTRING(descr,8), ROUND(above,2) from usbox_services, categories  
                where usbox_services.cat_idx = categories.cat_idx and usbox_services.tar_id = categories.tar_id 
                and vg_id in (SELECT vg_id FROM vgroups where agrm_id = (SELECT agrm_id FROM agreements 
                where uid = ? and oper_id = 1)) and oper_id = 1">>,
                                                                                     [RecAcc#account_details.uid], Context),
            LB_AccServices = {services, AccServices},

            ACCPhone_numbers = z_mydb:q(<<"SELECT if(substring(phone_number,8)='',CONCAT('(812) ', phone_number), 
                if(substring(phone_number,11)='', CONCAT('(',MID(phone_number,1,3),') ', right(phone_number,7)),
                CONCAT('(',MID(phone_number,2,3),') ',RIGHT(phone_number,7)))) from tel_staff 
                where vg_id in (SELECT vg_id FROM vgroups where 
                agrm_id = (SELECT agrm_id FROM `agreements` where uid = ? and oper_id = 1))">>,
                                                                                     [RecAcc#account_details.uid], Context),
            LB_ACCPhone_numbers = {phone_numbers, ACCPhone_numbers},

            ACCIPaddresses = z_mydb:q(<<"SELECT concat(INET_NTOA(segment),' / ',INET_NTOA(mask)) FROM staff
                where vg_id in (SELECT vg_id FROM vgroups where
                agrm_id = (SELECT agrm_id FROM agreements where uid = ? and oper_id = 1));">>,
                                                                                     [RecAcc#account_details.uid], Context),
            LB_ACCIPaddresses = {ip_addresses, ACCIPaddresses},

            [LB_company_name, LB_phone, LB_fax, LB_email, LB_bank_name, LB_gen_dir, LB_kont_person, 
                LB_CompanyAddr, LB_MailAddr, LB_ACCBalance, LB_Agreements, LB_ACCPhone_numbers, 
                LB_AccServices, LB_AccPayments, LB_ACCIPaddresses]
    end.

%%
%% test of m_search and pagination
%%
observe_search_query({search_query, {callslist, [{callsdirection,Direction},{callstype,CallsType},{from,StartDayInput},{limit,MaxCalls},{month,MonthInput},{till,EndDayInput}]}, _OffsetLimit}, Context) ->
  if
     MonthInput =/= undefined ->
         [MonthM, YearM] = string:tokens(MonthInput,"/"),
         zonnet_util:get_calls_list_by_period({from, list_to_integer(YearM), list_to_integer(MonthM), 1},{till, list_to_integer(YearM), list_to_integer(MonthM), calendar:last_day_of_the_month(list_to_integer(YearM), list_to_integer(MonthM))},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context);
     EndDayInput =/= undefined ->
         [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
         [DayE, MonthE, YearE] = string:tokens(EndDayInput,"/"),
         zonnet_util:get_calls_list_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearE), list_to_integer(MonthE), list_to_integer(DayE)},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context);
     StartDayInput =/= undefined ->
         [DayS, MonthS, YearS] = string:tokens(StartDayInput,"/"),
         zonnet_util:get_calls_list_by_period({from, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{till, list_to_integer(YearS), list_to_integer(MonthS), list_to_integer(DayS)},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context);
     true ->
      {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
      zonnet_util:get_calls_list_by_period({from, Year, Month, Day},{till, Year, Month, Day},{callsdirection,Direction},{callstype,CallsType},{limit,MaxCalls},Context)
  end;

observe_search_query({search_query, {callslist, _Args}, _OffsetLimit}, Context) ->
    {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
    file:write_file("/home/zotonic/iamstestnext",[lists:flatten(io_lib:format("~p", [_Args])),"\n\n"], [append]),
    zonnet_util:get_calls_list_by_period({from, Year, Month, Day},{till, Year, Month, Day},{callsdirection,"0,1"},{callstype,"1,6"},{limit,"3000"},Context);

observe_search_query(_, _Context) ->
    undefined.
%%
%% Just a test of z_notify as an alternative to z_event - event({postback, intervaltype, _TriggerId, _TargetId}, Context) 
%%
observe_postback_notify({postback_notify, "intervaltype_notify",_,_}, Context) ->
  try z_context:get_q("period",Context) of
      Period ->
          z_render:update("datepicker", z_template:render("_zonnet_widget_statistics_datepicker.tpl", [{period,Period}], Context), Context)
  catch
      error:_ ->
          z_render:growl_error(?__("Please input intervaltype.", Context), Context)
  end.


observe_foo({foo, []}, Context) -> 
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User -> 
            QueryResult = z_mydb:q(<<"select name from accounts where login = ?">>, [Z_User], Context),
            QueryResult
    end.

observe_zonnet_menu(zonnet_menu, Acc, Context) ->
    [
     #menu_item{id=menu_dashboard,
                label=?__("Dashboard", Context),
                url={zonnet} },
     #menu_item{id=zonnet_account,
                label=?__("Account", Context)},
     #menu_item{id=account_details,
                parent=zonnet_account,
                label=?__("Information", Context),
                url={zonnet_account_details}},
     #menu_item{id=finance_details,
                parent=zonnet_account,
                label=?__("Payments", Context),
                url={zonnet_finance_details}},
     #menu_item{id=account_statistics,
                parent=zonnet_account,
                label=?__("Statistics", Context),
                url={zonnet_statistics}},
     #menu_item{id=account_documents,
                parent=zonnet_account,
                label=?__("Documents", Context),
                url={zonnet_documents}}

    |Acc].


event({postback, assist_pay, _TriggerId, _TargetId}, Context) ->
  Assist_pay = z_context:get_q("assist_pay",Context),
  try zonnet_util:is_numeric(Assist_pay) of
    true ->
        Agrm_id = zonnet_util:get_main_agrm_id(Context),
        case zonnet_util:is_numeric(Agrm_id) of
          true ->
            OrderNumber = string:to_lower(z_ids:id(32)),
            AssistFolder = binary_to_list(m_config:get_value(mod_zonnet, assist_transaction_folder, Context)),
            case file:write_file(AssistFolder ++ "/" ++ OrderNumber, "attempt = 0") of
              ok ->
                Assist_URL = binary_to_list(m_config:get_value(mod_zonnet, assist_home_link, Context)),
                Merchant_ID = binary_to_list(m_config:get_value(mod_zonnet, assist_shop_id, Context)),
                Currency = binary_to_list(m_config:get_value(mod_zonnet, assist_shop_currency, Context)),
                Payment_URL = io_lib:format("~s?Merchant_ID=~s&OrderNumber=~s&OrderAmount=~s&OrderCurrency=~s&OrderComment=~s&Comment=~s&TestMode=0&Submit=Pay",[Assist_URL, Merchant_ID, OrderNumber, Assist_pay, Currency, Agrm_id, Agrm_id]),
                z_render:wire({redirect, [{location, Payment_URL}]}, Context);
              _ ->
                z_render:growl_error(?__("Can't open file for transaction. Please call to support.", Context), Context)
            end;
          false ->
            z_render:growl_error(?__("Please log in again.", Context), Context)
         end;
    false ->
        z_render:growl_error(?__("Please input a number.", Context), Context)
  catch
    error:_ ->
          z_render:growl_error(?__("Something went wrong. Please call to support.", Context), Context)
  end;

event({postback, invoiceme_progress, _TriggerId, _TargetId}, Context) ->
  z_convert:to_integer(z_context:get_q("invoiceme",Context)),
  z_render:update("make_invoice_table", z_template:render("zonnet_table_progress_invoice.tpl",[],Context), Context);

event({postback, invoiceme, _TriggerId, _TargetId}, Context) ->
  try z_convert:to_integer(z_context:get_q("invoiceme",Context)) of
      InvoiceAmount ->
         zonnet_http:create_invoice(InvoiceAmount, Context) 
  catch
      error:_ ->
          z_render:growl_error(?__("Please input integer number.", Context), Context)
  end;

event({submit, credit_form, _TriggerId, _TargetId}, Context) ->
  true = zonnet_util:credit_allowed(Context),
  Credit_amount = z_context:get_q("creditme",Context),
  try zonnet_util:is_numeric(Credit_amount) of
    true ->
        Agrm_id = zonnet_util:get_main_agrm_id(Context),
        case zonnet_util:is_numeric(Agrm_id) of
          true ->
            {ok_packet,_,_,_,_,_,_} = z_mydb:q_raw("insert into promise_payments (agrm_id, amount, prom_date, prom_till, debt) values( ?, ?/1.18, now(), DATE_ADD(NOW(), INTERVAL 5 DAY), ?/1.18)", [Agrm_id, Credit_amount, Credit_amount], Context),
            z_mydb:q_raw("update agreements set credit = ?/1.18 where agrm_id = ? and oper_id = 1 and archive = 0", [Credit_amount, Agrm_id], Context),
%%            z_render:growl([z_convert:to_list(Credit_amount),32,?__("credit applied",Context)], Context);
            z_render:update("dashboard_credit_table", z_template:render("zonnet_widget_dashboard_credit.tpl", [{headline,?__("Credit",Context)}], Context), Context);
          false ->
            z_render:growl_error(?__("Please log in again.", Context), Context)
        end;
    false ->
        z_render:growl_error(?__("Please choose value.", Context), Context)
  catch
      error:_ ->
          z_render:growl_error(?__("Something went wrong. Please call to support.", Context), Context)
  end;

event({postback, intervaltype_event, _TriggerId, _TargetId}, Context) ->
  try z_context:get_q("period",Context) of
      Period ->
          z_render:update("datepicker", z_template:render("_zonnet_widget_statistics_datepicker.tpl", [{period,Period}], Context), Context)
  catch
      error:_ ->
          z_render:growl_error(?__("Please input intervaltype.", Context), Context)
  end;

event({postback, fixed_costs, _TriggerId, _TargetId}, Context) ->
    StartDayInput = z_context:get_q("startDayInput",Context),
    EndDayInput = z_context:get_q("endDayInput",Context),
    MonthInput = z_context:get_q("monthInput",Context),
    z_render:update("fixed_costs_widget", z_template:render("zonnet_widget_statistics_fixed_costs.tpl", [{headline,?__("Costs for selected period, RUB (excl VAT)", Context)}, {idname, "fixed_costs_widget"}, {startDayInput, StartDayInput}, {endDayInput, EndDayInput}, {monthInput, MonthInput}], Context), Context);

event({postback, calls_list, _TriggerId, _TargetId}, Context) ->
    StartDayInput = z_context:get_q("startDayInput",Context),
    EndDayInput = z_context:get_q("endDayInput",Context),
    MonthInput = z_context:get_q("monthInput",Context),
    CallsType = z_context:get_q("callstype",Context),
    CallsDirection = z_context:get_q("callsdirection",Context),
    z_render:update("calls_list_widget", z_template:render("zonnet_widget_calls_list.tpl", [{headline,?__("Phone calls statistics", Context)}, {idname, "calls_list_widget"}, {startDayInput, StartDayInput}, {endDayInput, EndDayInput}, {monthInput, MonthInput}, {operator, CallsType}, {direction, CallsDirection}], Context), Context);

event({postback, refresh_invoices, _TriggerId, _TargetId}, Context) ->
    DocsMonthInput = z_context:get_q("docsmonthInput",Context),
    z_render:update("invoices_widget", z_template:render("zonnet_widget_invoices.tpl", [{headline,?__("Invoices", Context)}, {idname, "invoices_widget"}, {selectedmonth, DocsMonthInput}], Context), Context);

event({postback, refresh_vatinvoices, _TriggerId, _TargetId}, Context) ->
    DocsMonthInput = z_context:get_q("docsmonthInput",Context),
    z_render:update("vatinvoices_widget", z_template:render("zonnet_widget_vatinvoices.tpl", [{headline,?__("VAT Invoices", Context)}, {idname, "vatinvoices_widget"}, {selectedmonth, DocsMonthInput}], Context), Context);

event({postback, refresh_acts, _TriggerId, _TargetId}, Context) ->
    DocsMonthInput = z_context:get_q("docsmonthInput",Context),
    z_render:update("acts_widget", z_template:render("zonnet_widget_acts.tpl", [{headline,?__("Acts", Context)}, {idname, "acts_widget"}, {selectedmonth, DocsMonthInput}], Context), Context);

event(_A1, Context) ->
  z_render:growl_error(?__("Missed event happened.",Context), Context).

