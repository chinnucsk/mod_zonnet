
{% if reason == "pw" %}
<h2>{_ You entered an unknown username or password.  Please try again. _}</h2>
<br />
<h3>
    {_ Please note that password is case sensitive and check that your caps lock key is off. _}
</h3>
{% elif reason == "disabled_after_verification" %}
<h2>{_ Your account is currently blocked.  Please contact support. _}</h2>
{% endif %}


{% javascript %}
$("#logon_form form").unmask();
$("#logon_form #username").focus();
{% endjavascript %}
