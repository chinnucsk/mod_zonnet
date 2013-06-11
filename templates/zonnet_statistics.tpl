{% extends "zonnet_base.tpl" %}

{% block title %}{_ Dashboard _}{% endblock %}

{% block content %}
        <div>
            <div class="pull-right">
                <p class="admin-chapeau">
                    {_ Logged in as _}
                    <a href="{% url admin_edit_rsc id=m.acl.user %}">{{ m.acl.user.title }}</a>.
                </p>
            </div>
            
            <h2>{_ Statistics _}</h2>
            </br>

        </div>

        <div class="row">
            <div class="span6">

                {# Filter #}
                {% include "zonnet_widget_statistics_filter.tpl" headline=_"Phone calls statistics" %}

                {# Monthly fixed expenses #}
                {% include "zonnet_widget_statistics_fixed_costs.tpl" headline=_"Costs for current day, RUB (excl VAT)"  idname="fixed_costs_widget" %}

            </div>

            <div class="span6">

                {# Calls list #}
                {% include "zonnet_widget_calls_list.tpl" headline=_"Phone calls statistics" idname="calls_list_widget" %}

            </div>
            
        </div>

{% endblock %}
