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
            <th width="40%">{_ IP Addresses _}</th>
        </tr>
    </thead>
    <tbody>
        {% for zvg_id, ztar_id in m.zonnet[{accounts_tariffs_by_type type=2}] %}
            <tr>
               <td>{{ m.zonnet[{tariff_descr_by_tar_id tar_id=ztar_id }] }}</td>
               <td>{% for ip_address in m.zonnet[{ip_addresses_by_vg_id vg_id=zvg_id}] %} {{ ip_address }} </br> {% endfor %}</td>
            </tr>
        {% endfor %}
    </tbody>
</table>
{% endblock %}
