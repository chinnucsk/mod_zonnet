{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="zonnet_documents"} text=_"view documents"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="60%"><h4>{_ Fee name _}</h4></th>
            <th class="td-right" width="10%">{_ Price _}</th>
            <th class="td-center" width="15%">{_ Quantity _}</th>
            <th class="td-right" width="15%">{_ Cost _}</th>
        </tr>
    </thead>
    <tbody>
        {% for onnetservice, price, quantity, cost in m.zonnet.monthly_fees %}
          <tr><td>{{ onnetservice }}</td><td class="td-right">{{ price }}</td><td class="td-center">{{ quantity }}</td><td class="td-right">{{ cost }}</td></tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}

