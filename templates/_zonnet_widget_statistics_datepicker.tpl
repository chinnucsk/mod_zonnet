{% if period == "interval" %}
            <td>
                {% include "_zonnet_widget_interval_button.tpl" %}
                {% javascript %}
                  $('#startDay').datepicker();
                  $('#endDay').datepicker();
                {% endjavascript %}
            </td>
      <td class="td-center">
         <div class="date" id="startDay" data-date="{{ now|sub_month|date: 'd/m/Y' }}" data-date-format="dd/mm/yyyy" 
              data-date-autoclose="true" data-date-language={{ z_language }} data-date-start-date="-6m" 
              data-date-end-date="+0d">
                  {_ From: _}&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="startDayInput" type="text" class="input-small-zonnet" name="startDayInput" 
                                                    value="{{ now|sub_month|date: 'd/m/Y' }}" readonly/>
                  <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
            </td>
            <td class="td-center">
               <div class="date" id="endDay" data-date="{{ now|date: 'd/m/Y' }}" data-date-format="dd/mm/yyyy" data-date-autoclose="true" data-date-language={{ z_language }} data-date-start-date="-6m" data-date-end-date="+0d">{_ Till: _}&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="endDayInput" type="text" class="input-small-zonnet" name="endDayInput" value="{{ now|date: 'd/m/Y' }}" readonly/>
                  <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
            </td>
{% elif period == "month" %}
            <td>
                {% include "_zonnet_widget_interval_button.tpl" %}
            </td>
            <td class="td-right"colspan="2">
               <div class="date" id="selectMonth" data-date="{{ now|date: 'm/Y' }}" data-date-format="mm/yyyy" data-date-min-view-mode="months" data-date-autoclose="true"  data-date-language={{ z_language }} data-date-language={{ lang_code }} data-date-start-date="-6m" data-date-end-date="+0d">{_ Month: _}&nbsp;&nbsp;&nbsp;&nbsp;
                 <input id="monthInput" type="text" class="input-small-zonnet" name="monthInput" value="{{ now|date: 'm/Y' }}" readonly/>
                 <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
               {% javascript %}
                  $('#selectMonth').datepicker();
               {% endjavascript %}
            </td>
{% else %}
            <td>
                {% include "_zonnet_widget_interval_button.tpl" %}
            </td>
            <td class="td-right" colspan="2">
               <div class="date" id="startDay" data-date-format="dd/mm/yyyy" data-date-autoclose="true" data-date-language={{ z_language }} data-date-start-date="-6m" data-date-end-date="+0d">{_ Day: _}&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="startDayInput" type="text" class="input-small-zonnet" name="startDayInput" value="{% now 'd/m/Y' %}" readonly/>
                  <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
               {% javascript %}
                  $('#startDay').datepicker();
               {% endjavascript %}
            </td>
{% endif %}

