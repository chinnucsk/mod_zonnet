{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="zonnet"} text=_"dashboard"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
   <thead>
        <tr>
            <th>{_ # _}</th>
            <th>{_ Date _}</th>
            <th>{_ Counterparty _}</th>
            <th>{_ Sum _}</th>
            <th>{_ VAT _}</th>
            <th>{_ Total _}</th>
        </tr>
    </thead>
    <tbody>
    {% if m.zonnet.is_prepaid %}
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="34" month=selectedmonth }] %}
        <tr>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_num }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_date[2]|date:'Y-m-d' }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ oper_name }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ (tax_summ/18*100+tax_summ)|zonnet_round - tax_summ }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ tax_summ }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ (tax_summ/18*100+tax_summ)|zonnet_round }}</a></td>
        </tr>
      {% endfor %}
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="35" month=selectedmonth }] %}
        <tr>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_num }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_date[2]|date:'Y-m-d' }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ oper_name }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ (tax_summ/18*100)|zonnet_round }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ tax_summ }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ (tax_summ/18*100+tax_summ)|zonnet_round }}</a></td>
        </tr>
      {% endfor %}
    {% else %}
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="1" month=selectedmonth }] %}
        <tr>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_num }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_date[2]|date:'Y-m-d' }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ oper_name }}</a></td>
        </tr>
      {% endfor %}
    {% endif %}
    </tbody>
</table>
{% endblock %}

