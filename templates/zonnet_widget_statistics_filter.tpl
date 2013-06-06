{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="#"} text=_"refresh results"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
<tbody>
  <tr id="datepicker">
    {% include "_zonnet_widget_statistics_datepicker.tpl" %}
  </tr>
  <tr id="statistics_direction">
    {% include "_zonnet_widget_statistics_direction.tpl" %}
  </tr>
  <tr id="statistics_callstype">
    {% include "_zonnet_widget_statistics_callstype.tpl" %}
  </tr>
</tbody>
</table>
{% endblock %}

