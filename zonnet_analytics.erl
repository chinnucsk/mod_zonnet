-module(zonnet_analytics).
-author("Kirill Sysoev <kirill.sysoev@gmail.com>").

%% interface functions
-export([
     get_call_attempts_by_date/3
    ,get_call_attempts_by_retrodays/4
    ,get_call_attempts_by_retrodays/5
]).

-include_lib("zotonic.hrl").

get_call_attempts_by_date(PhoneNum, {Year, Month, Day}, Context) ->
    QueryString = io_lib:format("select cast(count(distinct(numfrom)) as char), cast(count(numfrom) as char) from tel001~w~2..0w~2..0w where numto like ~p", [Year, Month, Day, PhoneNum]),
    [QueryResult] = z_mydb:q(QueryString, Context),
    [[lists:flatten(io_lib:format("~w-~2..0w-~2..0w", [Year, Month, Day])) | QueryResult]].
%%    [[{Year, Month, Day} | QueryResult]].


get_call_attempts_by_retrodays(PhoneNum, {Year, Month, Day}, DaysAmount, Context) ->
    get_call_attempts_by_retrodays(PhoneNum, {Year, Month, Day}, DaysAmount, Context, []).

get_call_attempts_by_retrodays(PhoneNum, {Year, Month, Day}, DaysAmount, Context, Acc) ->
    if
       DaysAmount < 0 ->
           lists:reverse(Acc);
       DaysAmount >= 0 ->
           AccNew = Acc ++ get_call_attempts_by_date(PhoneNum, zonnet_util:countdown_day({Year, Month, Day}, DaysAmount), Context),
           get_call_attempts_by_retrodays(PhoneNum, {Year, Month, Day}, DaysAmount - 1, Context, AccNew)
    end.
    

