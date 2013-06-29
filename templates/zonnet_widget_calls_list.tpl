{% extends "zonnet_widget_dashboard.tpl" %}

{% block widget_headline %}
    {{ headline }}
{% endblock %}

{% block widget_class %}{% if last %}last{% endif %}{% endblock %}

{% block widget_content %}
{# <table id="calls_list_table" class="table table-condensed do_adminLinkedTable"> #}
<table id="calls_list_table" >
    <thead>
        <tr>
            <th >{_ Start time _}</th>
            <th ></th>
            <th >{_ Caller _}</th>
            <th >{_ Callee _}</th>
            <th class="td-center">{_ Min _}</th>
            <th class="td-center">{_ RUR _}</th>
        </tr>
    </thead>
    <tbody>
            {%  with m.search[{callslist from=startDayInput month=monthInput till=endDayInput callsdirection=direction callstype=operator limit="3000"}] as result %}
            {% for timefrom, numfrom, numto, duration, direction, amount in result %}
                <tr>
                   <td>{{ timefrom[2] }}</td>
                   <td class="td-left">{% if direction %}
                                             <i class="icon-arrow-right" title="{_ Outbound _}"></i>
                                         {% else %}
                                             <i class="icon-arrow-left" title="{_ Inbound _}"></i>
                                         {% endif %}
                   </td>
                   <td>{{ numfrom|pretty_phonenumber }}</td>
                   <td>{{ numto|pretty_phonenumber }}</td>
                   <td class="td-center">{{ duration }}</td>
                   <td class="td-right">{{ amount }}</td>
                </tr>
            {% endfor %}
            {% endwith %}
    </tbody>
    <tfoot>
        <tr>
			<th class="td-right" colspan="4">{_ Total (all pages): _}</th>
			<th class="td-center"></th>
			<th class="td-right"></th>
        </tr>
    </tfoot>
</table>

{% javascript %}
//var initSearchParam = $.getURLParam("filter");
var oTable = $('#calls_list_table').dataTable({

"bFilter" : true,
"aaSorting": [[ 0, "asc" ]],
"aLengthMenu" : [[10, 30, 100, -1], [10, 30, 100, "Все"]],
"iDisplayLength" : 10,
"oLanguage" : {
	"sInfoThousands" : " ",
	"sLengthMenu" : "_MENU_ строк на страницу",
	"sSearch" : "Фильтр:",
	"sZeroRecords" : "Ничего не найдено - извините",
	"sInfo" : "Просмотр с _START_ по _END_ из _TOTAL_ записей",
	"sInfoEmpty" : "Просмотр 0 записей",
	"sInfoFiltered" : "(Отфильтровано из _MAX_ записей)",
	"oPaginate" : {
		"sPrevious" : "Назад",
		"sNext" : "Вперед"
	}
},



 "fnFooterCallback": function ( nRow, aaData, iStart, iEnd, aiDisplay ) {
            /*
             * Calculate the total market share for all browsers in this table (ie inc. outside
             * the pagination)
             */
            var iTotalMinutes = 0;
            var iTotalMoney = 0;
            for ( var i=0 ; i<aaData.length ; i++ )
            {
                iTotalMinutes += aaData[i][4]*1;
                iTotalMoney += aaData[i][5]*1;
            }

            /* Calculate the market share for browsers on this page */
            var iPageMinutes = 0;
            var iPageMoney = 0;
            for ( var i=iStart ; i<iEnd ; i++ )
            {
                iPageMinutes += aaData[ aiDisplay[i] ][4]*1;
                iPageMoney += aaData[ aiDisplay[i] ][5]*1;
            }
             
            /* Modify the footer row to match what we want */
            var nCells = nRow.getElementsByTagName('th');
            nCells[1].innerHTML = parseInt(iTotalMinutes);
            nCells[2].innerHTML = parseFloat(iTotalMoney).toFixed(2);
        }


});
{% endjavascript %}

{% endblock %}

