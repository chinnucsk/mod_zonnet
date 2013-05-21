{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="50%"><h4>Статус учетной записи</h4></th>
            <th width="50%"><h4>Активна</h4></th>
        </tr>
    </thead>
    <tbody>
        <tr><td>Текущий баланс</td><td>{{ m.zonnet.account_balance }} руб.</td></tr>
    </tbody>
</table>
{% endblock %}

