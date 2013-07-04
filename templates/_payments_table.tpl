<h4>Платежи:</h4>

<table class="table table-striped">
    <thead>
        <tr>
            <th>{_ Date _}</th>
            <th>{_ Sum _}</th>
            <th>{_ Comment _}</th>
        </tr>
    </thead>
    <tbody>
    {% for amount, date, comment in payments %}
        <tr><td>{{ date }}</td><td>{{ amount }} {_ rub. _}</td><td>{{ comment }}</td></tr>
    {% endfor %}
    </tbody>
</table>
