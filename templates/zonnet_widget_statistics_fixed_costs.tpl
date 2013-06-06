{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="60%"><h4>{_ Service name _}</h4></th>
            <th class="td-right" width="15%">{_ Sum _}</th>
        </tr>
    </thead>
    <tbody>
        {% for onnetservice, price, quantity, cost in m.zonnet.monthly_fees %}
          <tr><td>{{ onnetservice }}</td><td class="td-right">{{ cost }}</td></tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}

