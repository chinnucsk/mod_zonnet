{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="45%">{_ Counterparty _}</th>
            <th width="25%">{_ Contract number _}</th>
            <th width="30%">{_ Contract date _}</th>
        </tr>
    </thead>
    <tbody>
        {% for agreement,date,operator in m.zonnet.agreements_table %}
            <tr><td>{{operator}}</td><td>{{agreement}}</td><td>{{ date[2]|date:"d F Y" }}</td></tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}

