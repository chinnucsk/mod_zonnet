-module(filter_pretty_phonenumber).
-export([
          pretty_phonenumber/2,
          pretty_phonenumber/3
]).

pretty_phonenumber(Number, _Context) ->
    RegExps = ["7812000000000000"],
    multiregexp(RegExps,Number).

pretty_phonenumber(Number, _Args, _Context) ->
    Number.

multiregexp([],Number) ->
    Number;
multiregexp([RE|RegExps],Number) ->
    case re:run(Number,RE,[{capture,none}]) of
    match ->
        re:replace(Number,RE,"",[{return,list}]);
    nomatch ->
        multiregexp(RegExps,Number)
    end.
