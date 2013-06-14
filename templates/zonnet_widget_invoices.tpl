{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
   <thead>
        <tr>
            <th>{_ # _}</th>
            <th>{_ Date _}</th>
            <th>{_ Counterparty _}</th>
        </tr>
    </thead>
    <tbody>
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="1,34,35" month="05/2013" }] %}
        <tr>
            <td>{{ order_num }}</td>
            <td>{{ order_date[2]|date:'Y-m-d' }}</td>
            <td>{{ oper_name }}</td>
        </tr>
      {% endfor %}

    </tbody>
</table>
{% endblock %}

