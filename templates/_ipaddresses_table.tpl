<p>{_ Allocated IP Addresses _}:</p>

{% for ip_address in ip_addresses %}
  {{ ip_address }} </br>
{% endfor %}
