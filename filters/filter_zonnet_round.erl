-module(filter_zonnet_round).
-export([
          zonnet_round/2,
          zonnet_round/3
]).

zonnet_round(Number, _Context) when is_integer(Number) ->
    Number;
zonnet_round(Number, _Context) when is_float(Number) ->
%    round(Number);
     io_lib:format("~.2f",[Number]);
zonnet_round(Number, _Context) ->
    Number.

zonnet_round(Number, _Args, _Context) ->
    Number.

