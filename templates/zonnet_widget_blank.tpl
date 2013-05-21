{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="#"} text=_"show all"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="35%"><h4>Пустой виджет</h4></th>
            <th width="65%"> </th>
        </tr>
    </thead>
    <tbody>
        <tr><td>Позиция</td><td>Значение</td></tr>
    </tbody>
</table>
{% endblock %}

