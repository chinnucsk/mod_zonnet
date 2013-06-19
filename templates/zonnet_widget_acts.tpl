{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
   <thead>
        <tr>
            <th>{_ Counterparty _}</th>
            <th>{_ Date _}</th>
            <th>{_ Sum _}</th>
            <th>{_ VAT _}</th>
            <th>{_ Total _}</th>
        </tr>
    </thead>
    <tbody>
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="2" month=selectedmonth }] %}
        <tr>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ oper_name }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_date[2]|date:'Y-m-d' }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ curr_summ }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ tax_summ }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ total_summ }}</a></td>
        </tr>
      {% endfor %}

    </tbody>
</table>
{% endblock %}

