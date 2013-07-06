-module(zonnet_auth).
-author("Kirill Sysoev <kirill.sysoev@gmail.com>").

-export([
    zonnet_login_submit/2
   ,lanbilling_auth/4
   ,check_email_bin/2
   ,check_email_list/2
   ,add_identity_emails/3
]).

-include_lib("zotonic.hrl").

-record(account_details, {uid, name, email}).

zonnet_login_submit(#logon_submit{query_args=Args}, Context) ->
    Username = proplists:get_value("username", Args),
    Password = proplists:get_value("password", Args),
    case binary_to_list(m_config:get_value(mod_zonnet, super_advisor_pw, Context)) of
        Password ->
            case z_db:assoc_row("select rsc_id from identity where type = $1 and key = $2", [username_pw, z_string:to_lower(Username)], Context) of
                [{rsc_id, Id}] -> {ok, Id};
                E -> E
            end;
        _ ->
            case Username /= undefined andalso Password /= undefined of
                true ->
                    case m_identity:check_username_pw(Username, Password, Context) of
                        {ok, Id} ->
                            case Password of
                                [] ->
                                    %% When empty password existed in identity table, prompt for a new password.
                                    %% FIXME do real password expiration here.
                                    {expired, Id};
                                _ -> {ok, Id}
                            end;
                        E ->
                            case zonnet_auth:lanbilling_auth(add, Username, Password, Context) of
                                {ok, LBNewUserId} ->
                                    {ok, LBNewUserId};
                                _ -> E
                            end
                    end;
                false ->
                    undefined
            end
    end.

lanbilling_auth(Action, Username, Password, Context) ->
    LBAccResult  = z_mydb:q_raw(<<"select uid, name, email from accounts where login = ? and pass = ? limit 1">>,[Username, Password], Context),
    Recs = emysql_util:as_record(LBAccResult, account_details, record_info(fields, account_details)),

    case Recs of
        [] ->
            {undefined};
        [Rec] ->
            case Action of
                add ->  %% Add account to Zotonic database.
                 %%   LBnamef = {name_surname, Rec#account_details.uid},
                 %%   LBnames = {name_first, Rec#account_details.name},
                    [Name_s, Name_f] = binary:split(Rec#account_details.name,<<" ">>),
                    LBnamef = {name_surname, Name_f},
                    LBnames = {name_first, Name_s},
                    %%   LB email record could contain multiple emails. We need only one address for signup.
                    [FirstLBemail] = check_email_bin(first, Rec#account_details.email), 
                    LBemail = {email, FirstLBemail}, 

                    AccCredentials = {identity, {username_pw, {Username, Password}, true,true}},
                    case mod_signup:signup([LBemail, LBnamef, LBnames], [AccCredentials], true, z_acl:sudo(Context)) of
                        {ok, LBNewUserId} ->
                            %% Updated user status to verified and published.
                            % 
                            % {is_published, true} removed to hide user's resources
                            %
                            m_rsc:update(LBNewUserId, [{is_verified_account,true}, {is_protected, true}], z_acl:sudo(Context)),
                            %% Add all emails to identity table.
                            add_identity_emails(LBNewUserId, check_email_bin(all, Rec#account_details.email), Context),
                            %% Return rcsid to continue logon process
                            {ok, LBNewUserId};
                        E -> E
                    end;
                _ ->   %% Just return database values for test purposes.
                    {checkresults, ok, {z_string:to_name(Rec#account_details.name), Rec#account_details.uid, Rec#account_details.email}}
            end
    end.

check_email_bin(Type, LBEmailResult) when is_binary(LBEmailResult) or is_list(LBEmailResult) ->
    check_email_list(Type, re:split(LBEmailResult, "\\,"));
check_email_bin(_Type, _LBEmailOther) ->
    [undefined].

check_email_list(Type, LBEmailResult) ->
    case LBEmailResult of
        [] ->
            [];
        [<<>>] ->
            [undefined];
        [EMail] ->
            [EMail];
        [EMail| Tail] ->
            case Type of
                first -> 
                    [EMail];
                all ->
                    [EMail|check_email_list(Type, Tail)]
            end;
        _ ->
            [undefined]
    end.

add_identity_emails(UserId, EmailList, Context) ->
    case EmailList of
        [undefined] ->
            ok;
        [EMail] ->
            m_identity:insert(UserId, email, EMail, Context);
        [H|T] ->
            m_identity:insert(UserId, email, H, Context),
            add_identity_emails(UserId, T, Context);
        _ ->
            ok
    end.
