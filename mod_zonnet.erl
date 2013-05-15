%% @author Kirill Sysoev <iam@onnet.su>
%% @date 2013-04-27%
%% @doc OnNet communications/innovations customer support module. 

-module(mod_zonnet).
-author("Kirill Sysoev <iam@onnet.su>").
-mod_title("Z OnNet").
-mod_description("OnNet communications innovations customer support module.").
-mod_prio(400).

-export([
get_account_data/1
]).

-include_lib("zotonic.hrl").

-record(account_details, {uid, name, phone, fax, email, bank_name, gen_dir_u, kont_person}).


get_account_data(Context) ->
    Username = m_identity:get_username(Context),
    LBAccResult = z_mydb:q_raw(<<"select uid, name, phone, fax, email, bank_name, gen_dir_u, kont_person from accounts where login = ? limit 1">>, [Username], Context),
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
            CompanyAddr = z_mydb:q(<<"select address from accounts_addr where uid = ? and type = ? limit 1">>, [RecAcc#account_details.uid, 0], Context),
            LB_CompanyAddr = {company_addr, CompanyAddr},
            MailAddr = z_mydb:q(<<"select address from accounts_addr where uid = ? and type = ? limit 1">>, [RecAcc#account_details.uid, 2], Context),
            LB_MailAddr = {mail_addr, MailAddr},
            [LB_company_name, LB_phone, LB_fax, LB_email, LB_bank_name, LB_gen_dir, LB_kont_person, LB_CompanyAddr, LB_MailAddr]
    end.
