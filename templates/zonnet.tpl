{% extends "base.tpl" %}

{% block title %}{_ Personal account _}{% endblock %}

{% block content %}
<p> {{ company_name }} </p>
<p>Телефон: {{ phone }} </p>
<p>Факс: {{ fax }} </p>
<p> {{ email }} </p>
<p> {{ bank_name }} </p>
<p> {{ gen_dir }} </p>
<p> {{ kont_person }} </p>
<p>Юр. адрес: {{ company_addr  }} </p>
<p>Почтовый адрес: {{ mail_addr  }} </p>
{% endblock %}
