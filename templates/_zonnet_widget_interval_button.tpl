<div class="btn-group pull-left">
<a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">
  <i class="icon-calendar"></i>
  {_ choose interval type _}
  <span class="caret"></span>
</a>
<ul class="dropdown-menu nav-list nav">
    {% wire name="intervaltype_event" action={postback postback="intervaltype_event" delegate="mod_zonnet" qarg="startDayInput" qarg="endDayInput" qarg="monthInput"} %}
    <li><a href="#" onclick="z_event('intervaltype_event', { period: 'day' });">{_ Day _}</li></a>
    <li><a href="#" onclick="z_notify('intervaltype_notify', { period: 'month' });" >{_ Month _}</li></a>
    <li><a href="#" onclick="z_event('intervaltype_event', { period: 'interval' });">{_ Interval _}</li></a>
</ul>
</div>
