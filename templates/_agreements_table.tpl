<h4> Договоры: </h4>
<table class="table table-striped">
    <thead>
        <tr>
            <th>{_ Counterparty _}</th>
            <th>{_ Contract number _}</th>
            <th>{_ Contract date _}</th>
        </tr>
    </thead>
    <tbody>
    {% for agreement,date,operator in agreements %}
        <tr><td>{{operator}}</td><td>{{agreement}}</td><td>{{ date[2]|date:"d F Y" }}</td></tr> 
    {% endfor %}
    </tbody>
</table>

