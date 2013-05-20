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
            
            <h2>{_ Dashboard _}</h2>
            </br>

        </div>

        <div class="row">
            <div class="span6">
                {# Account details #}
                {% include "zonnet_widget_dashboard_latest.tpl" cat="zonnet_account_details" headline=_"Account details"              col1=m.zonnet.item col2=_"COL2Test" %}

                {# Latest modified persons #}
                {% include "zonnet_widget_dashboard_latest.tpl" cat="person" headline=_"Latest modified persons" %}
            </div>

            <div class="span6">

                {# Latest modified locations #}
                {% if m.rsc['location'].id and m.acl.view['location'] %}
                {% include "zonnet_widget_dashboard_latest.tpl" cat="location" headline=_"Latest modified locations" last=1 %}
                {% endif %}

                {# Latest modified events #}
                {% if m.rsc['event'].id and m.acl.view['event'] %}
                {% include "zonnet_widget_dashboard_latest.tpl" cat="event" headline=_"Latest modified events" last=1 %}
                {% endif %}
                
                {# Latest modified media items #}
                {% include "zonnet_widget_dashboard_latest.tpl" cat="media" headline=_"Latest modified media items" media=1 last=1 %}
            </div>
            
        </div>
{% endblock %}
