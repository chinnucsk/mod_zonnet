<h4>Платежи:</h4>

<table class="table table-striped">
    <thead>
        <tr>
            <th>Дата</th>
            <th>Сумма</th>
            <th>Коментарий</th>
        </tr>
    </thead>
    <tbody>
    {% for amount, date, comment in payments %}
        <tr><td>{{ date }}</td><td>{{ amount }} руб.</td><td>{{ comment }}</td></tr>
    {% endfor %}
    </tbody>
</table>
