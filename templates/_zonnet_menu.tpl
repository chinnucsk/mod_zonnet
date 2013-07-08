<div class="navbar navbar-inverse navbar-fixed-top">

    <div class="navbar-inner">
        <div class="container-fluid">

        
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>
            <a class="brand hidden-phone" href="/" title="{_ visit site _}"><img alt="OnNet logo" src="/lib/images/logo.gif"></a>
            <a class="brand visible-phone" href="/" title="{_ visit site _}"><img alt="OnNet logo" src="/lib/images/logo_white_bordered_50.png"></a>

            <div class="nav-collapse collapse">

            <div class="span2 offset2 zonnet_call"><a class="white_link" href="tel:+78123634500">(812) 363-45-00</a></div>
            <div class="span2 zonnet_call"><a class="white_link" href="mailto:info@onnet.su">info@onnet.su</a></div>

                <ul class="nav pull-right">
                    {% for id, item in m.zonnet_menu %}
                        {% if item.items %}
                        <li class="dropdown" id="nav-{{ id }}">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#nav-{{ id }}">
                                {% if item.icon %}<i class="icon-{{ item.icon }} icon-white"></i>{% endif %}
                                {{ item.label|escape }}
                                <b class="caret"></b>
                            </a>
                            <ul class="dropdown-menu">
                            {% for id, item in item.items %}
                                {% if item.separator %}
                                <li class="divider"></li>
                                {% else %}
                                <li><a href="{{ item.url }}">
                                    {% if item.icon %}<i class="icon-{{ item.icon }}"></i>{% endif %}
                                    {{ item.label|escape }}</a>
                                </li>
                                {% endif %}
                            {% endfor %}
                            </ul>
                        </li>
                        {% else %}
                        <li class="">
                            <a href="{{ item.url }}">{{ item.label|escape }}</a>
                        </li>
                        {% endif %}
                    {% endfor %}
                    <li>
                        {% all include "_admin_headeritem.tpl" %}
                    </li>
                    <li>
                        <a href="#" id="{{ #logoff }}" title="{_ Log Off _}"><i class="icon-off icon-white"></i></a>
                        {% wire id=#logoff action={confirm title=_"Confirm logoff" text=_"Are you sure you want to exit the customer interface?"
                                                   action={redirect dispatch=`logoff`}} %}
                    </li>

                </ul>

            </div>
            
        </div>
    </div>
</div>
