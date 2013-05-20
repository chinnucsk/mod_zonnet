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
            
            <h2>{_ Account details _}</h2>
            </br>

        </div>

        <div class="row">
            <div class="span6">

                {# Company details #}
                {% include "zonnet_widget_dashboard_latest.tpl" cat="text" headline=_"Company details" %}

            </div>

            <div class="span6">

                {# Current agreements #}
                {% include "zonnet_widget_dashboard_latest.tpl" cat="media" headline=_"Current agreements" media=1 last=1 %}

            </div>
            
        </div>
{% endblock %}
