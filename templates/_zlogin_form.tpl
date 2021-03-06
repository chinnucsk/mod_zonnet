<iframe src="/lib/images/spinner.gif" id="logonTarget" name="logonTarget" style="display:none"></iframe>
<form id="logon_form" method="post" action="postback" class="z_logon_form" target="logonTarget">
    {% if not hide_title %}
       <p id="onnetimg" align="middle"><img src="/lib/images/onnet_logo1.png" style="width: 300px;" alt="" /></p><br />
    {% endif %}
    
    <input type="hidden" name="page" value="{{ page|escape }}" />
    <input type="hidden" name="handler" value="username" />

    <div class="control-group">
        <label for="username" class="control-label">{_ Username _}</label>
        <div class="controls">
	    <input type="text" id="username" name="username" value=""  autofocus="autofocus" autocapitalize="off" autocomplete="on" tabindex=1/>
            {% validate id="username" type={presence} %}
        </div>
    </div>

    <div class="control-group">
        <label for="password" class="control-label">{_ Password _}</label>
	        <button class="btn btn-primary btn-large pull-right" style="margin-right: 10px" type="submit">{_ Log on _}</button>
        <div class="controls">
	    <input type="password" id="password" name="password" value="" autocomplete="on" tabindex=2/>
        </div>
    </div>

    <div class="control-group">
        <div class="controls">
	        <label class="checkbox" title="{_ Stay logged on unless I log off. _}">
            	<input type="checkbox" name="rememberme" value="1" />
                {_ Remember me _}
            </label>
        </div>
    </div>

</form>
