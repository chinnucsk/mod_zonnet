-module(filter_pretty_phonenumber).
-export([
          pretty_phonenumber/2,
          pretty_phonenumber/3
]).

pretty_phonenumber(Number, _Context) ->
    RegExps = ["7812000000000000", "^\\d{7}$", "^7\\d{10}$", "^\\d{10}$"],
    multiregexp(RegExps,Number).

pretty_phonenumber(Number, _Args, _Context) ->
    Number.

multiregexp([],Number) ->
    Number;
multiregexp([RE|RegExps],Number) ->
    case re:run(Number,RE) of
    {match,[{0,16}]} ->
        re:replace(Number,RE,"",[{return,list}]);
    {match,[{0,11}]} ->
        [[],"7", Code, ShortNumber] = re:split(Number,"(.)(...)(.......)",[{return,list},{parts,0}]),
        lists:flatten(["(", Code, ") ", ShortNumber]);
    {match,[{0,10}]} ->
        [[], Code, ShortNumber] = re:split(Number,"(...)(.......)",[{return,list},{parts,0}]),
        lists:flatten(["(", Code, ") ", ShortNumber]);
    {match,[{0,7}]} ->
        lists:flatten(["(812) ", Number]);
    nomatch ->
        multiregexp(RegExps,Number)
    end.