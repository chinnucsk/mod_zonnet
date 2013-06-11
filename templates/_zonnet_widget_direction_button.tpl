<div class="btn-group pull-left">
<a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">
  <i class="icon-resize-horizontal"></i>
  {_ choose calls direction _}
  <span class="caret"></span>
</a>
<ul class="dropdown-menu nav-list nav">
    {% wire name="intervaltype_event" action={postback postback="intervaltype_event" delegate="mod_zonnet"} %}
    <li><a href="#" onclick="$('#callsdirection').val('1'); $('#direction_text').text('{_ Outbound calls _}');">{_ Outbound calls _}</li></a>
    <li><a href="#" onclick="$('#callsdirection').val('0'); $('#direction_text').text('{_ Inbound calls _}');">{_ Inbound calls _}</li></a>
    <li><a href="#" onclick="$('#callsdirection').val('0,1'); $('#direction_text').text('{_ All _}');">{_ All _}</li></a>
</ul>
</div>
