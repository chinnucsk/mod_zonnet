-module(controller_zonnet).
-author("Test").

-export([
         is_authorized/2
]).

-define(LOGON_REMEMBERME_COOKIE, "z_logon").

-include_lib("controller_html_helper.hrl").

is_authorized(ReqData, Context) ->
    z_acl:wm_is_authorized(use, z_context:get(acl_module, Context, mod_zonnet), zonnet_login, ReqData, Context).

html(Context) ->
    Template = z_context:get(template, Context, "zonnet.tpl"),
    Html = z_template:render(Template, [], Context),
    z_context:output(Html, Context).

