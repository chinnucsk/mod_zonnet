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
            
            <h2>{_ Documents _}</h2>
            </br>

        </div>

        <div class="row">
            <div class="span6">

                {# Period Datepicker #}
                {% include "zonnet_widget_documents_datepicker.tpl" headline=_"Period" %}

                {# Calls report #}
                {% include "zonnet_widget_calls_reports.tpl" headline=_"Calls report" idname="calls_reports_widget" %}

                <div class="hidden-phone">
                    <br /><br />
                    <p id="elcactoimg" align="center"><img  width="60%" src="/lib/images/3.gif" alt="" /></p>
                </div>

            </div>

            <div class="span6">

                {% if m.zonnet[{get_docs_list docsids="1,34,35" month=selectedmonth }] %}
                    {# Invoices #}
                    {% include "zonnet_widget_invoices.tpl" headline=_"Invoices" idname="invoices_widget" %}
                {% endif %}

                {# Crazy Russian Document - SchetFacturaZ #}
                {% include "zonnet_widget_vatinvoices.tpl" headline=_"VAT Invoices" idname="vatinvoices_widget" %}

                {# Acts #}
                {% include "zonnet_widget_acts.tpl" headline=_"Acts" idname="acts_widget" %}

            </div>
            
        </div>

{% endblock %}
