{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="zonnet_finance_details"} text=_"make payments"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
{% for agrm_id,amount,prom_date,prom_till,debt,pay_id in m.zonnet.credit_info %}
    <thead>
        <tr>
            <th width="35%"><h4>{{ pay_id }}</h4></th>
            <th width="65%"> </th>
        </tr>
    </thead>
    <tbody>
            <tr><td>Обещанный платеж</td><td>{{ amount }} руб.</td></tr>
            <tr><td>Срок погашения</td><td>{{ prom_till[2] }} руб.</td></tr>
    </tbody>
{% empty %}
    <thead>
        <tr>
            <th width="50%"><h4>Выполнить обещанный платеж</h4></th>
            <th width="25%"> </th>
            <th width="25%"> </th>
        </tr>
    </thead>
    <tbody>
            <tr><td>Введите сумму от 1000 до 3000 руб.</td><td>Окошко</td><td>Кнопка</td></tr>
    </tbody>
{% endfor%}
</table>
{% endblock %}
