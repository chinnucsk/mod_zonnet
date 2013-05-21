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
            
            <h2>{_ Documents _}</h2>
            </br>

        </div>

        <div class="row">
            <div class="span6">

                {# Blank #}
                {% include "zonnet_widget_blank.tpl" headline=_"Blank" %}

            </div>

            <div class="span6">

                {# Blank #}
                {% include "zonnet_widget_blank.tpl" headline=_"Blank" %}

            </div>
            
        </div>
{% endblock %}
