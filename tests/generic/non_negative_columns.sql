{% test non_negative_columns(model, columns) %}
    select *
    from {{ model }}
    where
        {% for column in columns %}
        {{ adapter.quote(column) }} < 0{% if not loop.last %} or{% endif %}
        {% endfor %}
{% endtest %}
