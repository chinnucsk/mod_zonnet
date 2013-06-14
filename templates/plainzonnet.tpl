{% extends "zonnet_base.tpl" %}

        {% lib
                "css/bootstrap-admin.css"
                "css/zp-menuedit.css"
                "css/zotonic-admin.css"
                "css/z.modal.css"
                "css/jquery.loadmask.css"
        %}

{% block title %}{_ Personal account _}{% endblock %}

{% block content %}
<h3> {{ company_name }} </h3>
<h4>Текущий баланс: {{ accbalance }} р.</h4>
</br>
<table class="table table-striped">
    <thead>
        <tr>
            <th></th>
            <th></th>
        </tr>
    </thead>
    <tbody>
        <tr><td>Телефон:</td><td>{{ phone }}</td></tr>
        <tr><td>Факс:</td><td>{{ fax }}</td></tr>
        <tr><td>Эл. почта:</td><td>{{ email }}</td></tr>
        <tr><td>Банк:</td><td>{{ bank_name }}</td></tr>
        <tr><td>Руководитель:</td><td>{{ gen_dir }}</td></tr>
        <tr><td>Контактное лицо:</td><td>{{ kont_person }}</td></tr>
        <tr><td><p>Юр. адрес:</td><td>{{ company_addr  }}</td></tr>
        <tr><td><p>Почтовый адрес:</td><td>{{ mail_addr  }}</td></tr>
    </tbody>
</table>

</br>
{% include "_agreements_table.tpl" %}
</br>
{% include "_services_table.tpl" %}
</br>
{% include "_payments_table.tpl" %}
</br>
{% include "_numbers_table.tpl" %}
</br>
{% include "_ipaddresses_table.tpl" %}

</br>

<h4> Notifier {foo} results:</h4>
     {% for number in m.notifier.first[{foo}] %} 
         {{ number }} </br> 
     {% endfor %} 
<h5> End of {foo} results </h5>

</br>

<h4> Model m_zonnet results:</h4>
     {% for item in m.zonnet.modtest %} 
         {{ item }} </br> 
         {% print item %} </br> 
     {% endfor %} 
<p> test1 </p>
{{m.zonnet.ttt}}
{% print m.zonnet.ttt %}
<p> test2 </p>
{{m.zonnet.item}}
{% print m.zonnet.iamitem %}
<h5> Another of m_zonnet results </h5>
{% print m.zonnet.middle.abrakadabra %}
<h5> End of m_zonnet results </h5>
{% print m.zonnet[{accounts_table fields="name" limit=3}] %}
{{ m.zonnet[{accounts_table fields="name" limit=3}] }}
<h5> End2 of m_zonnet results </h5>
{% print m.zonnet.agreements_table %}
{% for agreement, date, company in m.zonnet.agreements_table %}
{{ agreement }} - {{ date }} - {{ company }}
{% endfor%}

{% tabs id="tabs" %}
<div id="tabs">
  <ul>
    <li><a href="#tabs-1">Nunc tincidunt</a></li>
    <li><a href="#tabs-2">Proin dolor</a></li>
    <li><a href="#tabs-3">Aenean lacinia</a></li>
  </ul>
  <div id="tabs-1">
    <p>Proin elit arcu, rutrum commodo, vehicula tempus.</p>
  </div>
  <div id="tabs-2">
    <p>Morbi tincidunt, dui sit amet facilisis feugiat.</p>
  </div>
  <div id="tabs-3">
    <p>Mauris eleifend est et turpis.</p>
  </div>
</div>


{% print m.zonnet.credit_allowed %}
</br>

{{ m.zonnet.credit_allowed }}

</br>


{% print m.zonnet.credit_info %}
{% for agrm_id,amount,prom_date,prom_till,debt,pay_id in m.zonnet.credit_info %}
{{ agrm_id }} - {{ amount }} - {{ prom_date[2] }} - {{ prom_till[2] }} - {{ debt }} - {{ pay_id }}
{% endfor%}


<div class="btn-group pull-right block-add-block">
    <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">
        {_ + choose period type _}
        <span class="caret"></span>
    </a>
    <ul class="dropdown-menu nav-list nav">
            <li class="nav-header">nav-header</li>
                <li><a href="#" data-block-type="test1">test1</li></a>
                <li><a href="#" data-block-type="test1">test12</li></a>
                <li><a href="#" data-block-type="test2">test21</li></a>
    </ul>
</div>

{% wire type="submit" id="credit" postback={mailing_page id=id on_success=on_success} action={dialog_close} delegate=delegate %}
<form id="credit" method="post" action="postback">

    <p><input type="radio" name="creditme" value="1180" /> 1180 {_ rub. _}
       <input type="radio" name="creditme" value="2360" /> 2360 {_ rub. _}
       <input type="radio" name="creditme" value="2360" /> 3540 {_ rub. _}
    </p>

    {% button class="btn btn-mini" text=_"Send mailing" %}

</form>


{% if m.zonnet[{is_service_provided type=0}] %} <p> TYpe = 0 </p> {% endif %} 
{% if m.zonnet[{is_service_provided type=3}] %} <p> TYpe = 3 </p> {% endif %} 
{% if m.zonnet[{is_service_provided type=4}] %} <p> TYpe = 4 </p> {% endif %} 
{% if m.zonnet[{is_service_provided type=5}] %} <p> TYpe = 5 </p> {% endif %} 

{% print m.zonnet.monthly_fees %}

<input type="text" style="width:80px" name="dt:ymd:{{ is_end }}:{{ name }}" value="{{ date|date:'Y-m-d' }}" class="do_datepicker" />

{% print m.zonnet.get_accounts_emails %}


{% for email in m.zonnet.get_accounts_emails %} {{ email }} {% endfor %}


{{ [now|sub_month, now]|datediff:"D" }}


<table class="table table-striped">
    <thead>
        <tr>
            <th>oper_id</th>
            <th>order_num</th>
            <th>order_date</th>
            <th>curr_summ</th>
            <th>tax_summ</th>
            <th>total_summ</th>
        </tr>
    </thead>
    <tbody>
      {% for oper_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet.get_docs_list %}
        <tr>
            <td>{{ oper_id }}</td>
            <td>{{ order_num }}</td>
            <td>{{ order_date[2]|date:'Y-m-d' }}</td>
            <td>{{ curr_summ }}</td>
            <td>{{ tax_summ }}</td>
            <td>{{ total_summ }}</td>
        </tr>
      {% endfor %}
    </tbody>
</table>

<br />
<br />
<br />

<table class="table table-striped">
    <thead>
        <tr>
            <th>oper_id</th>
            <th>order_num</th>
            <th>order_date</th>
            <th>curr_summ</th>
            <th>tax_summ</th>
            <th>total_summ</th>
        </tr>
    </thead>
    <tbody>
      {% for oper_id, order_num, order_date, curr_summ, tax_summ, total_summ in m.zonnet[{get_docs_list docsids="3" month="05/2013" }] %}
        <tr>
            <td>{{ oper_id }}</td>
            <td>{{ order_num }}</td>
            <td>{{ order_date[2]|date:'Y-m-d' }}</td>
            <td>{{ curr_summ }}</td>
            <td>{{ tax_summ }}</td>
            <td>{{ total_summ }}</td>
        </tr>
      {% endfor %}
    </tbody>
</table>




{% endblock %}
