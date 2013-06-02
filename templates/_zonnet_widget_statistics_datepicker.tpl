      {% if period == "interval" %}

    <thead>
        <tr>
            <th colspan="3"><h4>{_ Select interval _}</h4></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td width="40%" class="td-center">
               <div class="date" id="startDay" data-date="{{ now|sub_month|date: 'd/m/Y' }}" data-date-format="dd/mm/yyyy" data-date-autoclose="true" data-date-language={{ z_language }} data-date-start-date="-6m" data-date-end-date="+0d">{_ From: _}&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="startDay1" type="text" class="input-small-zonnet" name="startday1" value="{{ now|sub_month|date: 'd/m/Y' }}" readonly/>
                  <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
            </td>
            <td width="40%" class="td-center">
               <div class="date" id="endDay" data-date="{{ now|date: 'd/m/Y' }}" data-date-format="dd/mm/yyyy" data-date-autoclose="true" data-date-language={{ z_language }} data-date-start-date="-6m" data-date-end-date="+0d">{_ Till: _}&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="endDay1" type="text" class="input-small-zonnet" name="endday1" value="{{ now|date: 'd/m/Y' }}" readonly/>
                  <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
            </td>
            <td>
               {% button class="btn btn-mini pull-right" text=_"proceed"%}
            </td>
        </tr>
    </tbody>
            {% javascript %}
              $('#startDay').datepicker();
              $('#endDay').datepicker();
            {% endjavascript %}

       {% elif period == "month" %}
    <thead>
        <tr>
            <th colspan="3"><h4>{_ Select month _}</h4></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td width="40%" class="td-center">
               <div class="date" id="selectMonth" data-date="{{ now|date: 'm/Y' }}" data-date-format="mm/yyyy" data-date-min-view-mode="months" data-date-autoclose="true"  data-date-language={{ z_language }} data-date-language={{ lang_code }} data-date-start-date="-6m" data-date-end-date="+0d">{_ From: _}&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="selectMonth2" type="text" class="input-small-zonnet" name="dateday" value="{{ now|date: 'm/Y' }}" readonly/>
                  <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
            </td>
            <td width="40%" class="td-center">
            </td>
            <td>
               {% button class="btn btn-mini pull-right" text=_"proceed"%}
            </td>
        </tr>
    </tbody>
            {% javascript %}
              $('#selectMonth').datepicker();
            {% endjavascript %}

       {% else %}
    <thead>
        <tr>
            <th colspan="3"><h4>{_ Select day _}</h4></th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td width="40%" class="td-center">
               <div class="date" id="selectDay" data-date-format="dd/mm/yyyy" data-date-autoclose="true" data-date-language={{ z_language }} data-date-start-date="-6m" data-date-end-date="+0d">{_ From: _}&nbsp;&nbsp;&nbsp;&nbsp;
                  <input id="startDay1" type="text" class="input-small-zonnet" name="startday1" value="{% now 'd/m/Y' %}" readonly/>
                  <span class="add-on"><i class="icon-calendar"></i></span>
               </div>
            </td>
            <td width="40%" class="td-center">
            </td>
            <td>
               {% button class="btn btn-mini pull-right" text=_"proceed"%}
            </td>
        </tr>
    </tbody>
            {% javascript %}
              $('#selectDay').datepicker();
            {% endjavascript %}

       {% endif %}

