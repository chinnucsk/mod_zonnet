-module(m_zonnet_menu).
-author("<kirill.sysoev@gmail.com>").

-include_lib("include/zotonic.hrl").
-include_lib("modules/mod_zonnet/include/zonnet_menu.hrl").

%% interface functions
-export([
    m_find_value/3,
    m_to_list/2,
    m_value/2
]).


%% @spec m_find_value(Key, Source, Context) -> term()
m_find_value(user, #m{value=undefined}, Context) ->
    z_acl:user(Context);
m_find_value(is_customer, #m{value=undefined}, Context) ->
    z_acl:is_allowed(use, mod_zonnet, Context);
m_find_value(Action, #m{value=undefined} = M, _Context) 
    when Action == use orelse Action == admin orelse Action == view
    orelse Action == delete orelse Action == update orelse Action == insert ->
    M#m{value={is_allowed, Action}};
m_find_value(is_allowed, #m{value=undefined} = M, _Context) ->
    M#m{value=is_allowed};
m_find_value(Action, #m{value=is_allowed} = M, _Context) ->
    M#m{value={is_allowed, Action}};
m_find_value(Object, #m{value={is_allowed, Action}}, Context) when is_binary(Object) ->
    z_acl:is_allowed(Action, z_convert:to_atom(Object), Context);
m_find_value(Object, #m{value={is_allowed, Action}}, Context) ->
    z_acl:is_allowed(Action, Object, Context).

%% @spec m_to_list(Source, Context) -> List
m_to_list(_, Context) ->
    menu(Context).

%% @spec m_value(Source, Context) -> term()
m_value(#m{value=undefined}, _Context) ->
    undefined.


menu(Context) ->
    case z_acl:is_allowed(use, mod_zonnet, Context) of
        false -> [];
        true ->
            F = fun() ->
                        Menu = z_notifier:foldl(zonnet_menu, [], Context),
                        hierarchize(Menu, Context)
                end,
            z_depcache:memo(F, 
                            {zonnet_menu, z_acl:user(Context), z_context:language(Context)},
                            ?WEEK,
                            [zonnet_menu],
                            Context)
    end.



hierarchize(Items, Context) ->
    hierarchize(undefined, Items, Context).

hierarchize(Id, All, Context) ->
    {Matches, Rest} = partition(Id, All),
    Matches1 = [mixin(C, Rest, Context) || C <- Matches],
    lists:filter(fun(I) -> item_visible(I, Context) end, Matches1).
    

partition(Key, Items) ->
    lists:partition(fun(#menu_item{parent=K}) when K =:= Key ->
                            true;
                       (#menu_separator{parent=K}) when K =:= Key ->
                            true;
                       (_) ->
                            false end, Items).

mixin(Item=#menu_item{id=Id, url=UrlDef}, All, Context) ->
    Url = item_url(UrlDef, Context),
    Props = [{url, Url},
             {items, hierarchize(Id, All, Context)}
             | proplists:delete(url, lists:zip(record_info(fields, menu_item), tl(tuple_to_list(Item))))],
    {Id, Props};

mixin(#menu_separator{visiblecheck=C}, _All, _Context) ->
    {undefined, [{separator, true}, {visiblecheck, C}]}.

item_url({Rule}, Context) ->
    z_dispatcher:url_for(Rule, Context);
item_url({Rule, Args}, Context) ->
    z_dispatcher:url_for(Rule, Args, Context);
item_url(X, _) ->
    X.

item_visible({_Key, ItemProps}, Context) ->
    case proplists:get_value(visiblecheck, ItemProps) of
        undefined ->
            proplists:get_value(url, ItemProps) =/= undefined orelse
                lists:filter(fun(#menu_separator{}) -> false; (_) -> true end, proplists:get_value(items, ItemProps, [])) =/= [];
        F when is_function(F) ->
            F();
                {acl, Action, Object} ->
            z_acl:is_allowed(Action, Object, Context)
    end.
                     
