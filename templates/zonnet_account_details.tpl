{% extends "zonnet_base.tpl" %}

{% block title %}{_ Dashboard _}{% endblock %}

{% block content %}
        <div>
            <div class="pull-right">
                <p class="admin-chapeau">
                    {_ Logged in as _}
                    <a href="/zonnet/account_details">{{ m.acl.user.title }}</a>.
                </p>
            </div>
            
            <h2>{_ Account details _}</h2>
            </br>

        </div>

        <div class="row">
            <div class="span6">

                {# Company details #}
                {% include "zonnet_widget_account_details.tpl" cat="text" headline=_"Company details" %}

            </div>

            <div class="span6">

                {# Current agreements #}
                {% include "zonnet_widget_agreements.tpl" headline=_"Current agreements" %}

            </div>
            
        </div>
{% endblock %}
