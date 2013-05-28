{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="zonnet_finance_details"} text=_"make payments"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="35%"><h4>Статус учетной записи</h4></th>
            <th width="65%">{% if m.zonnet.acount_status == 0 %}<h4> {_ Active _}</h4> 
                            {% else %}<h4 class="zalarm"> {_ Blocked _} </h4>{% endif %}
            </th>
        </tr>
    </thead>
    <tbody>
        <tr><td>Текущий баланс</td><td>{{ m.zonnet.account_balance }} руб.</td></tr>
        {% for amount, date, comment in m.zonnet[{account_payments limit=1}] %}
            <tr><td>Последний платеж</td><td>{{ date }} - {{ amount }} руб. - {{ comment }}</td></tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}

