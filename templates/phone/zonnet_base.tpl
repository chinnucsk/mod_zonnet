<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <title>{% block title %}{_ Zonnet _}{% endblock %} &mdash; {{ m.config.site.title.value|default:"Zonnet" }} Customer</title>
        
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <meta name="description" content="" />
        <meta name="author" content="Arjan Scherpenisse" />

        {% include "_js_include_jquery.tpl" %}
        {% lib
                "css/bootstrap-admin.css"
                "css/bootstrap-admin-responsive.css"

                "css/zp-menuedit.css"
                "css/zotonic-admin.css"
                "css/z.modal.css"
                "css/jquery.loadmask.css"
        %}
        {% lib "css/z.growl.css" %}
        {% lib "js/modules/z.notice.js" %}
        {% lib "css/zonnet.css"  %}
        {% lib "css/datepicker.css"  %}
        {% lib "js/bootstrap-datepicker.js"  %}
        {% lib "js/locales/bootstrap-datepicker.ru.js"  %}

        <!-- DataTables CSS -->
        <link rel="stylesheet" type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css">
        <!-- DataTables -->
        <script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>

        <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
        <!--[if lt IE 9]>
            <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
        <![endif]-->

        {% block head_extra %}
        {% endblock %}
    </head>
    <body class="{% block bodyclass %}{% endblock %}">

	{% wire name="adminwidget_toggle" action={adminwidget_toggle} %}

        {% block navigation %}
        {% include "_zonnet_menu.tpl" %}
        {% endblock %}

        <div class="container">
	    {% block content %}{% endblock %}
	</div>

	{% include "_admin_js_include.tpl" %}
	{% block js_extra %}{% endblock %}
	
	{% stream %}
	{% script %}

	{% block tinymce %}{% endblock %}
        
	{% block html_body_admin %}{% all include "_html_body_admin.tpl" %}{% endblock %}
</body>
</html>
