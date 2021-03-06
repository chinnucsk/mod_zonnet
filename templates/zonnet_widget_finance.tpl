{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="zonnet"} text=_"dashboard"%}
{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="50%"><h4>{_ Account status _}</h4></th>
            <th width="50%">{% if m.zonnet.acount_status == 0 %}<h4 class="zprimary"> {_ Active _}</h4> 
                            {% else %}<h4 class="zalarm"> {_ Blocked _} </h4>{% endif %}
            </th>
        </tr>
    </thead>
    <tbody>
        {% if m.zonnet.is_prepaid %}
            <tr><td>{_ Current balance _}</td><td>{{ m.zonnet.account_balance }} {_ rub. _}</td></tr>
        {% else %}
            <tr><td>{_ Current month expenses _}</td><td>{{ m.zonnet.calc_curr_month_exp }} {_ rub. _}</td></tr>
        {% endif %}
    </tbody>
</table>
{% endblock %}

