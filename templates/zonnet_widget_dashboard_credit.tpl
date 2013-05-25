{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
{% for agrm_id,amount,prom_date,prom_till,debt,pay_id in m.zonnet.credit_info %}
    <thead>
        <tr>
            <th width="35%">Статус </th>
            <th width="65%">{% if pay_id == 0 %}<h4> Активный </h4>{% elif  pay_id == -1 %}<h4> Просрочен </h4>{% else %}<h4> Неопределен </h4>{% endif %}</th>
        </tr>
    </thead>
    <tbody>
            <tr><td>Обещанный платеж</td><td>{{ amount }} руб.</td></tr>
            <tr><td>Срок погашения</td><td>{{ prom_till[2] }} руб.</td></tr>
    </tbody>
{% empty %}
    <thead>
        <tr>
            <th width="90%" colspan="2"><h4>Выполнить обещанный платеж</h4></th>
            <th width="10%"> </th>
        </tr>
    </thead>
    <tbody>
            <tr>
                {% wire type="submit" id="credit-form" postback="credit_form" delegate="mod_zonnet" %}
                <form id="credit-form" method="post" action="postback">
                <td>Выберите сумму</td>
                <td>
                       <input type="radio" name="creditme" value="1180" /> 1180 {_ rub. _}
                       <input type="radio" name="creditme" value="2360" /> 2360 {_ rub. _}
                       <input type="radio" name="creditme" value="3540" /> 3540 {_ rub. _}
                </td>
                <td>{% button class="btn btn-mini pull-right" text=_"proceed"%}</td>
                </form>
            </tr>
    </tbody>
{% endfor%}
</table>
{% endblock %}
