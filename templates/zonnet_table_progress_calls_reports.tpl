    <thead>
        <tr>
            <th><h4>{_ Please wait _} ...</h4></th>
        </tr>
    </thead>
    <tbody>
        <tr>
           <td>
              <div class="zbarcontainer">
                  <div id="zonnet_progress" class="progress progress-striped active" style="margin-bottom: 0px!important;">
                       <div id="zonnet_bar" class="bar" style="width: 0%;"></div>
                  </div>
              </div>
           </td>
        </tr>
    </tbody>

{% javascript %}
var progress = setInterval(function() {
    var $progressdiv = $('#zonnet_progress').width();
    var $bar = $('#zonnet_bar');
    
    if ($bar.width() >= $progressdiv*0.95) {
        clearInterval(progress);
        $('#zonnet_progressdiv').removeClass('active');
    } else {
        $bar.width($bar.width() + $progressdiv/10);
    }
    var curr_progress = $bar.width()*100/$progressdiv;
    $bar.text(curr_progress.toPrecision(2) + "%");
}, 2400);
{% endjavascript %}
