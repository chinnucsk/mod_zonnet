-module(controller_zonnet).
-author("Test").

-export([is_authorized/2
        ]).

-include_lib("controller_html_helper.hrl").

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(use, z_context:get(acl_module, Context, mod_zonnet), logon, ReqData, Context).

html(Context) ->
    Variables = mod_zonnet:get_account_data(Context),
    Template = z_context:get(template, Context, "zonnet.tpl"),
    Html = z_template:render(Template, Variables, Context),
    z_context:output(Html, Context).
