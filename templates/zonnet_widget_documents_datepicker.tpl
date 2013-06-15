{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
    {% button class="btn btn-mini pull-right" action={postback postback="refresh_invoices" delegate="mod_zonnet" qarg="docsmonthInput"} action={postback postback="refresh_vatinvoices" delegate="mod_zonnet" qarg="docsmonthInput"} action={postback postback="refresh_acts" delegate="mod_zonnet" qarg="docsmonthInput"} text=_"refresh results"%}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
<table class="table do_adminLinkedTable">
<tbody>
  <tr>
      <td>
        {_ Choose month _}
      </td>
      <td class="td-right"colspan="2">
         <div class="date" id="documentsMonth" data-date="{{ now|sub_month|date: 'm/Y' }}" data-date-format="mm/yyyy" data-date-min-view-mode="months" data-date-autoclose="true"  data-date-language={{ z_language }} data-date-language={{ lang_code }} data-date-start-date="-6m" data-date-end-date="-1m">{_ Month: _}&nbsp;&nbsp;&nbsp;&nbsp;
         <input id="docsmonthInput" type="text" class="input-small-zonnet" name="docsmonthInput" value="{{ now|sub_month|date: 'm/Y' }}" readonly/>
         <span class="add-on"><i class="icon-calendar"></i></span>
         </div>
         {% javascript %}
            $('#documentsMonth').datepicker();
         {% endjavascript %}
      </td>
  </tr>
</tbody>
</table>
{% endblock %}

