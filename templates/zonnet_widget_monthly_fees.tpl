{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="65%"><h4>{_ Fee name _}</h4></th>
            <th width="35%">{_ RUB, excl VAT _}</th>
        </tr>
    </thead>
    <tbody>
        {% for onnetservice, fee in m.zonnet.monthly_fees %}
          <tr><td>{{ onnetservice }}</td><td>{{ fee }}</td></tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}

