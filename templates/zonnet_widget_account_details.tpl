{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% if dashboard %}
    {% button class="btn btn-mini pull-right" action={redirect dispatch="zonnet_account_details"} text=_"show all"%}
    {% endif %}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
    <thead>
        <tr>
            <th width="35%">{{ m.zonnet[{accounts_table fields="name" limit=1}] }}</th>
            <th width="65%"> </th>
        </tr>
    </thead>
    <tbody>
     {% if not dashboard %}
        <tr><td>ИНН / КПП</td><td>{{ m.zonnet[{accounts_table fields="inn" limit=1}] }} / 
                                  {{ m.zonnet[{accounts_table fields="kpp" limit=1}] }}</td></tr>
     {% endif %}
        <tr><td>Контактное лицо</td><td>{{ m.zonnet[{accounts_table fields="kont_person" limit=1}] }}</td></tr>
        <tr><td>E-mail</td><td>{{ m.zonnet[{accounts_table fields="email" limit=1}] }}</td></tr>
        <tr><td>Телефон</td><td>{{ m.zonnet[{accounts_table fields="phone" limit=1}] }}</td></tr>
     {% if not dashboard %}
        <tr><td>Факс</td><td>{{ m.zonnet[{accounts_table fields="fax" limit=1}] }}</td></tr>
        <tr><td>Юридический адрес</td><td>{{ m.zonnet[{accounts_addr_table type=0}] }}</td></tr>
        <tr><td>Почтовый адрес</td><td>{{ m.zonnet[{accounts_addr_table type=1}] }}</td></tr>
        <tr><td>Адрес доставки счета</td><td>{{ m.zonnet[{accounts_addr_table type=2}] }}</td></tr>
        <tr><td>Директор</td><td>{{ m.zonnet[{accounts_table fields="gen_dir_u" limit=1}] }}</td></tr>
        <tr><td>Главный бухгалтер</td><td>{{ m.zonnet[{accounts_table fields="gl_buhg_u" limit=1}] }}</td></tr>
     {% endif %}
    </tbody>
</table>
{% endblock %}

