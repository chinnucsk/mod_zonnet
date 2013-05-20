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
    case m_identity:get_username(Context) of
        undefined -> [];
        Z_User ->
            QueryString = lists:flatten(io_lib:format("select ~s from accounts where login = \'~s\' limit ~p",[list_to_atom(Fields),Z_User,Limit])),
            [QueryResult] = z_mydb:q(QueryString, Context),
            QueryResult
    end;
m_find_value(_V, #m{value=numtest}, _Context) -> 
    ["M_numtest", _V];
m_find_value(_V, #m{value=modtest}, _Context) -> 
    ["M_modtest", _V];
m_find_value(_V, #m{value=undefined}, _Context) -> 
    ["M_Undefined", _V];
m_find_value(_V, _VV, _Context) -> 
    [_V,_VV,"m_zonnet_find_value_mismatch"].

m_to_list(_V, _Context) ->
    [_V,"m_to_list"].

m_value(#m{value=V}, _Context) -> V.
