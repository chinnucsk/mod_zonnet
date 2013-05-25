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
            
            <h2>{_ Payments _}</h2>
            </br>

        </div>

        <div class="row">
            <div class="span6">

                {# Account status #}
                {% include "zonnet_widget_finance.tpl" cat="text" headline=_"Account" %}

                {# Make payment #}
                {% include "zonnet_widget_make_payment.tpl" cat="text" headline=_"Online payment" %}

                {# Make invoce #}
                {% include "zonnet_widget_make_invoice.tpl" cat="text" headline=_"Wire transfer" %}

                {# Make credit #}
                {% if m.zonnet.credit_able %}
                {# Credit status #}
                {% include "zonnet_widget_dashboard_credit.tpl" headline=_"Credit" %}
                {% endif %}

            </div>

            <div id="paytab" class="span6">

                {# Payments List #}
                {% include "zonnet_widget_payments_list.tpl" headline=_"Payments list" lines=10 %}

            </div>
            
        </div>
{% endblock %}
