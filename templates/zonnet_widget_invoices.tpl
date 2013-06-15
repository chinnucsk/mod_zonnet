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
    {% if m.zonnet.is_prepaid %}
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="34,35" month=selectedmonth }] %}
        <tr>
            <td>{{ order_num }}</td>
            <td>{{ order_date[2]|date:'Y-m-d' }}</td>
            <td>{{ oper_name }}</td>
        </tr>
      {% endfor %}
    {% else %}
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="1" month=selectedmonth }] %}
        <tr>
            <td>{{ order_num }}</td>
            <td>{{ order_date[2]|date:'Y-m-d' }}</td>
            <td>{{ oper_name }}</td>
        </tr>
      {% endfor %}
    {% endif %}
    </tbody>
</table>
{% endblock %}

