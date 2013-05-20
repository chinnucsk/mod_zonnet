{% extends "base.tpl" %}

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
{% with m.zonnet[1] as result %}
    {% print result %}
{% endwith %}
{% endblock %}
