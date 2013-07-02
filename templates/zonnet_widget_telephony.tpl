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
            <th width="60%"><h4>{_ Tariff name _}</h4></th>
            <th width="40%">{_ Phone Numbers _}</th>
        </tr>
    </thead>
    <tbody>
        {% for zvg_id, ztar_id in m.zonnet[{accounts_tariffs_by_type type=1}] %}
            <tr>
               <td>{{ m.zonnet[{tariff_descr_by_tar_id tar_id=ztar_id }] }}</td>
               <td>{% for number in m.zonnet[{numbers_by_vg_id vg_id=zvg_id}] %} {{ number }} {% if forloop.counter|is_even %}</br>{% else %} &nbsp;&nbsp;&nbsp;&nbsp;  {% endif %}{% endfor %}</td>
            </tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}
