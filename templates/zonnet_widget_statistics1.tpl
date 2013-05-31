{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
<div class="btn-group pull-right zblock-add-block">
    <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">
        {_ + choose interval type _}
        <span class="caret"></span>
    </a>
    <ul class="dropdown-menu nav-list nav">
                {% wire name="intervaltype_event" action={postback postback="intervaltype_event" delegate="mod_zonnet"} %}
                <li><a href="#" onclick="z_event('intervaltype_event', { period: 'day' });">{_ day _}</li></a>
                <li><a href="#" onclick="z_notify('intervaltype_notify', { period: 'month' });" >{_ month _}</li></a>
                <li><a href="#" onclick="z_event('intervaltype_event', { period: 'interval' });">{_ interval _}</li></a>
    </ul>
</div>
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table id="datepicker" class="table do_adminLinkedTable">
  {% include "zonnet_widget_statistics_datepicker.tpl" %}
</table>
{% endblock %}

