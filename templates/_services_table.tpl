<h4>Предоставляемые услуги (без учета НДС 18%):</h4>
<table class="table table-striped">
    <thead>
        <tr>
            <th>Название</th>
            <th>Стоимость, {_ rub. _}</th>
        </tr>
    </thead>
    <tbody>
    {% for service, price in services %}
        <tr><td>{{ service }}</td><td>{{ price }}</td></tr>
    {% endfor %}
    </tbody>
</table>

