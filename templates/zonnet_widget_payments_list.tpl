{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% if lines %}
        {% button class="btn btn-mini pull-right" action={update target="paytab" template="zonnet_widget_payments_list.tpl" headline=_"Payments list"} text=_"show all" %}
    {% else %}
        {% button class="btn btn-mini pull-right" action={update target="paytab" template="zonnet_widget_payments_list.tpl" headline=_"Payments list" lines=10} text=_"last ten" %}
    {% endif %}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="30%">Дата</th>
            <th width="30%">Сумма</th>
            <th width="40%">Коментарий</th>
        </tr>
    </thead>
    <tbody>
        {% if lines %}
            {% for amount, date, comment in m.zonnet[{account_payments limit=lines}] %}
                <tr><td>{{ date }}</td><td>{{ amount }} руб.</td><td>{{ comment }}</td></tr>
            {% endfor %}
        {% else %}
            {% for amount, date, comment in m.zonnet.account_payments %}
                <tr><td>{{ date }}</td><td>{{ amount }} руб.</td><td>{{ comment }}</td></tr>
            {% endfor %}
        {% endif %}
    </tbody>
</table>
{% endblock %}

