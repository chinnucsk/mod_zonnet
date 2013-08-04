{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% if not m.zonnet[{get_docs_list docsids="39" month=selectedmonth }] %} {% button class="btn btn-mini pull-right" action={postback postback="callsreportme_progress" delegate="mod_zonnet"} action={postback postback="callsreportme" delegate="mod_zonnet" qarg="docsmonthInput"} text=_"generate" %} {% endif %}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table id="calls_reports_table" class="table do_adminLinkedTable">
    <tbody>
      {% for oper_name, order_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="39" month=selectedmonth }] %}
        <tr>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ order_date[2]|date:'Y-m-d' }}</a></td>
            <td><a href="/getlbdocs/id/{{order_id}}">{{ oper_name }}</a></td>
        </tr>
      {% endfor %}
    </tbody>
</table>

{% endblock %}

