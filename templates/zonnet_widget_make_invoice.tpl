{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_content %}
<table id="make_invoice_table" class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th colspan="3"><h4>{_ Issue an invoice _}</h4></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td width="50%">{_ Enter the amount, excluding VAT _}</td>
            <td><input class="input input-small-zonnet" type="text" id="invoiceme" name="invoiceme" value="" /> {_ rub. _}
                {% validate id="invoiceme" type={numericality minimum=0 maximum=100000} %}
            </td>
            <td>{% button class="btn btn-mini pull-right" action={postback postback="invoiceme_progress" delegate="mod_zonnet"} action={postback postback="invoiceme" delegate="mod_zonnet" qarg="invoiceme"} text=_"proceed"%}</td>
        </tr>
    </tbody>
</table>
{% endblock %}

