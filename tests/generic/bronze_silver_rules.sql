{% test bronze_silver_rules(model, entity, required_columns, accepted_values, range_checks={}) %}
    with incoming as (
        {% if entity == 'customers' %}
            {{ silver_input_customers(model) }}
        {% elif entity == 'orders' %}
            {{ silver_input_orders(model) }}
        {% else %}
            {{ exceptions.raise_compiler_error('Unknown entity: ' ~ entity) }}
        {% endif %}
    ),
    validation as (
        select
            *,
            concat_ws('; ',
                ''
                {% for column in required_columns %}
                , case when {{ adapter.quote(column) }} is null
                    then '{{ column }}: required value missing or cast failed' end
                {% endfor %}
                {% for column, values in accepted_values.items() %}
                , case when {{ adapter.quote(column) }} is not null
                    and {{ adapter.quote(column) }} not in (
                        {% for value in values %}
                        '{{ value | replace("'", "''") }}'{% if not loop.last %},{% endif %}
                        {% endfor %}
                    ) then '{{ column }}: value outside allowed list' end
                {% endfor %}
                {% for column, limits in range_checks.items() %}
                , case when {{ adapter.quote(column) }} < {{ limits['min'] }}
                    or {{ adapter.quote(column) }} > {{ limits['max'] }}
                    then '{{ column }}: value outside allowed range' end
                {% endfor %}
            ) as validation_errors
        from incoming
    )
    select * from validation
    where validation_errors <> ''
{% endtest %}
