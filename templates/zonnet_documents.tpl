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

                {# Period Datepicker #}
                {% include "zonnet_widget_documents_datepicker.tpl" headline=_"Period" %}

                {# Invoices #}
                {% include "zonnet_widget_invoices.tpl" headline=_"Invoices" idname="invoices_widget" %}

            </div>

            <div class="span6">

                {# Crazy Russian Document - SchetFacturaZ #}
                {% include "zonnet_widget_vatinvoices.tpl" headline=_"VAT Invoices" idname="vatinvoices_widget" %}

                {# Acts #}
                {% include "zonnet_widget_acts.tpl" headline=_"Acts" idname="acts_widget" idname="acts_widget" %}

            </div>
            
        </div>

{% endblock %}
