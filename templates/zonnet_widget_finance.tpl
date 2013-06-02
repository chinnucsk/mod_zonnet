{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="50%"><h4>Статус учетной записи</h4></th>
            <th width="50%">{% if m.zonnet.acount_status == 0 %}<h4 class="zprimary"> {_ Active _}</h4> 
                            {% else %}<h4 class="zalarm"> {_ Blocked _} </h4>{% endif %}
            </th>
        </tr>
    </thead>
    <tbody>
        {% if m.zonnet.is_prepaid %}
            <tr><td>Текущий баланс</td><td>{{ m.zonnet.account_balance }} руб.</td></tr>
        {% else %}
            <tr><td>Расход за текущий месяц</td><td>{{ m.zonnet.calc_curr_month_exp }} руб.</td></tr>
        {% endif %}
    </tbody>
</table>
{% endblock %}

