%% -*- coding: utf-8 -*-
-module(service_zonnet_callslist).
-author("Kirill Sysoev").
-svc_title("Calls list.").
-svc_needauth(true).

-export([process_get/2]).

-include_lib("zotonic.hrl").

process_get(_ReqData, Context) ->

    FreeNumbersList = z_mydb:q(<<"select number_id, number, price from all_phones_status where ocupated_date = '0000-00-00' and state = 1 and publish = 1">>, Context),
    Reply = [{"aaData", z_convert:to_json(my_convert(FreeNumbersList))}],

    {struct, Reply}.

my_convert([]) -> [];
my_convert([[Time,CID,Direction]|T]) -> [{Time,CID,Direction}]++my_convert(T).
