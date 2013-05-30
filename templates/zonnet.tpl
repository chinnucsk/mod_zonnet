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
                {% include "zonnet_widget_account_details.tpl" headline=_"Account details" dashboard %}

                {# Account status #}
                {% include "zonnet_widget_dashboard_finance.tpl" headline=_"Account" %}

                {% if m.zonnet.credit_able %}
                {# Credit status #}
                {% include "zonnet_widget_dashboard_credit.tpl" headline=_"Credit" idname="dashboard_credit_table" %}
                {% endif %}
            </div>

            <div class="span6">
                {# Account details #}
                {% include "zonnet_widget_monthly_fees.tpl" headline=_"Monthly fees" %}

                {% if m.zonnet[{is_service_provided type=4}] %}
                {# Account status #}
                {% include "zonnet_widget_telephony.tpl" headline=_"Telephony" %}
                {% endif %}

                {% if m.zonnet[{is_service_provided type=0}] %}
                {# Credit status #}
                {% include "zonnet_widget_internet.tpl" headline=_"Internet" %}
                {% endif %}
            </div>
            
        </div>
{% endblock %}
