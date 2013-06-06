{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table table-condensed do_adminLinkedTable">
    <thead>
        <tr>
            <th colspan="2">{_ Start time _}</th>
            <th >{_ Caller _}</th>
            <th >{_ Callee _}</th>
            <th class="td-center">{_ Min _}</th>
            <th class="td-center">{_ RUR _}</th>
        </tr>
    </thead>
    <tbody>
            {%  with m.search.paged[{callslist pagelen=100 page=q.page}] as result %}
            {% pager result=result hide_single_page=1 %}
            {% for timefrom, numfrom, numto, duration, direction, amount in result %}
                <tr>
                   <td>{{ timefrom[2] }}</td>
                   <td class="td-left">{% if direction %}
                                             <i class="icon-arrow-right" title="{_ Outbound _}"></i>
                                         {% else %}
                                             <i class="icon-arrow-left" title="{_ Inbound _}"></i>
                                         {% endif %}
                   </td>
                   <td>{{ numfrom }}</td>
                   <td>{{ numto }}</td>
                   <td class="td-center">{{ duration }}</td>
                   <td class="td-right">{{ amount }}</td>
                </tr>
            {% endfor %}
            {% endwith %}
    </tbody>
</table>
{% endblock %}

