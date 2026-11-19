{% test unique_columns(model, columns) %}
    {% if columns | length == 0 %}
        {{ exceptions.raise_compiler_error('unique_columns requires at least one column.') }}
    {% endif %}

    -- Each column must be unique independently, not just as a composite key.
    -- Nulls are excluded, matching dbt's built-in unique test.
    with column_counts as (
        select
            {% for column in columns %}
            {{ adapter.quote(column) }} as value_{{ loop.index }},
            count(*) over (partition by {{ adapter.quote(column) }})
                as occurrences_{{ loop.index }}{% if not loop.last %},{% endif %}
            {% endfor %}
        from {{ model }}
    ),

    validation as (
        select
            *,
            concat_ws('; ',
                {% for column in columns %}
                case when value_{{ loop.index }} is not null
                    and occurrences_{{ loop.index }} > 1
                    then '{{ column | replace("'", "''") }}: duplicate value' end
                    {% if not loop.last %},{% endif %}
                {% endfor %}
            ) as validation_errors
        from column_counts
    )

    select *
    from validation
    where validation_errors <> ''
{% endtest %}
