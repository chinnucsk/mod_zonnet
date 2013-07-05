{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th colspan="3"><h4>{_ ASSIST - Electronic Payment System _}</h4></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td width="50%">{_ Enter an amount to pay _}</td>
            <td><input class="input input-small-zonnet" type="text" id="assist_pay" name="assist_pay" value="" /> {_ rub. _}
                {% validate id="assist_pay" type={numericality minimum=0 maximum=15000 not_a_number_message=_"Must be a number."} %}
            </td>
            <td>{% button class="btn btn-mini pull-right" action={postback postback="assist_pay" delegate="mod_zonnet" qarg="assist_pay"} text=_"proceed"%}</td>
        </tr>
    </tbody>
</table>
{% endblock %}

