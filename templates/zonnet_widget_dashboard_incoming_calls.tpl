{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="zonnet_statistics"} text=_"show statistics"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
{# <table id="incoming_calls_list_table" class="table table-condensed do_adminLinkedTable"> #}
<table id="incoming_calls_list_table" >
    <thead>
        <tr>
            <th >{_ Start time _}</th>
            <th ></th>
            <th >{_ Caller _}</th>
            <th >{_ Callee _}</th>
            <th class="td-center">{_ Min _}</th>
        </tr>
    </thead>
    <tbody>
            {%  with m.search[{callslist from=today_will_be_chosen_by_defailt month=useless till=useless callsdirection="0" callstype="1" limit="5"}] as result %}
            {% for timefrom, numfrom, numto, duration, direction, amount in result %}
                <tr>
                   <td>{{ timefrom[2] }}</td>
                   <td class="td-left">{% if direction %}
                                             <i class="icon-arrow-right" title="{_ Outbound _}"></i>
                                         {% else %}
                                             <i class="icon-arrow-left" title="{_ Inbound _}"></i>
                                         {% endif %}
                   </td>
                   <td>{{ numfrom|pretty_phonenumber }}</td>
                   <td>{{ numto|pretty_phonenumber }}</td>
                   <td class="td-center">{{ duration }}</td>
                </tr>
            {% endfor %}
            {% endwith %}
    </tbody>
</table>

{% javascript %}
var oTable = $('#incoming_calls_list_table').dataTable({
"sDom": 't',
"bFilter" : false,
"aaSorting": [[ 0, "asc" ]]
});
{% endjavascript %}

{% endblock %}

