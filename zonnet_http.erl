-module(zonnet_http).
-author("Kirill Sysoev <kirill.sysoev@gmail.com>").

%% interface functions
-export([
     lb_login/1
    ,lb_logout/1
    ,create_invoice/2
    ,create_callsreport/2
]).

-include_lib("zotonic.hrl").

lb_login(Context) ->
    EncType = "application/x-www-form-urlencoded",
    Url = binary_to_list(m_config:get_value(mod_zonnet, lb_url, Context)),
    LB_User = binary_to_list(m_config:get_value(mod_zonnet, lb_user, Context)),
    LB_Password = binary_to_list(m_config:get_value(mod_zonnet, lb_password, Context)),
    AuthStr = io_lib:format("login=~s&password=~s",[LB_User, LB_Password]),
    httpc:set_options([{cookies, enabled}]),
    httpc:request(post, {Url, [], EncType, lists:flatten(AuthStr)}, [], []).

lb_logout(Context) ->
    EncType = "application/x-www-form-urlencoded",
    Url = binary_to_list(m_config:get_value(mod_zonnet, lb_url, Context)),
    httpc:request(post, {Url, [], EncType, lists:flatten("devision=99")}, [], []).

create_invoice(Amount, Context) ->
    Uid = zonnet_util:get_uid(Context),
    InvoiceNum = zonnet_util:get_next_doc_number("35", Context),
    Url = binary_to_list(m_config:get_value(mod_zonnet, lb_url, Context)),
    EncType = "application/x-www-form-urlencoded",
    {{Year, Month, Day}, {_, _, _}} = erlang:localtime(),
    MakeInvoiceStr = io_lib:format("devision=108&doctype=2&a_year=~p&a_month=~p&a_day=~p&startnum=~s&b_year=~p&b_month=~p&orsum=~p&docid=35&advSearchList=&docfor=3&userid=~s&agrmid=0&operid=1&comment=&async_call=1&generate=1",[Year, Month, Day, InvoiceNum, Year, Month, Amount, Uid]),
    lb_login(Context),
    case httpc:request(post, {Url, [], EncType, lists:flatten(MakeInvoiceStr)}, [], []) of
        {ok, {{_, 200, _}, _, Body}} ->
            lb_logout(Context),
            case re:run(Body, "success: true", [{capture, none}]) of
                match ->
%                    OrderId = zonnet_util:get_last_order_id("35", Context1),
 %                   Location = io_lib:format("http://iam.onnet.su:8000/getlbdocs/id/~s",[OrderId]),
                    z_render:update("make_invoice_table", z_template:render("zonnet_table_ready_invoice.tpl", [], Context), Context);
                _ ->
		    z_render:growl("Success not mutched", Context)
            end;
        _ ->
            lb_logout(Context),
	    z_render:growl("Bad httpc", Context)
    end.


create_callsreport(DocsMonthInput, Context) ->
    Uid = zonnet_util:get_uid(Context),
    Url = binary_to_list(m_config:get_value(mod_zonnet, lb_url, Context)),
    EncType = "application/x-www-form-urlencoded",
    [Month, Year] = string:tokens(DocsMonthInput,"/"),
    Day = calendar:last_day_of_the_month(list_to_integer(Year), list_to_integer(Month)),
    MakeInvoiceStr = io_lib:format("devision=108&doctype=0&a_year=~s&a_month=~s&a_day=~p&startnum=&b_year=~s&b_month=~s&asrent=1&docid=39&advSearchList=&usergroup=0&docfor=3&userid=~s&agrmid=0&operid=0&comment=&async_call=1&generate=1",[Year, Month, Day, Year, Month,  Uid]),
    lb_login(Context),
    case httpc:request(post, {Url, [], EncType, lists:flatten(MakeInvoiceStr)}, [], []) of
        {ok, {{_, 200, _}, _, Body}} ->
            lb_logout(Context),
            case re:run(Body, "success: true", [{capture, none}]) of
                match ->
                    z_render:update("calls_reports_widget", z_template:render("zonnet_widget_calls_reports.tpl", [{headline,?__("Calls report", Context)}, {idname, "calls_reports_widget"}, {selectedmonth, DocsMonthInput}], Context), Context);
     %%               z_render:update("calls_reports_table", z_template:render("zonnet_table_ready_calls_reports.tpl", [], Context), Context);
                _ ->
		    z_render:growl("Success not mutched", Context)
            end;
        _ ->
            lb_logout(Context),
	    z_render:growl("Bad httpc", Context)
    end.

