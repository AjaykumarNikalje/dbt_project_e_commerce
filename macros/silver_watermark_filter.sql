{% macro silver_watermark_filter(model_name) %}
    {# Read existing Silver state without ref(): a ref would create a DAG cycle. #}
    {% set state = namespace(relation=none) %}
    {% if execute and not flags.FULL_REFRESH %}
        {% set node = graph.nodes.get('model.' ~ project_name ~ '.' ~ model_name) %}
        {% if node is none %}
            {{ exceptions.raise_compiler_error('Unknown Silver model: ' ~ model_name) }}
        {% endif %}
        {% set state.relation = adapter.get_relation(
            database=node.database, schema=node.schema, identifier=node.alias) %}
    {% endif %}
    {% if state.relation is not none %}
        where (
            try_cast(source_updated_at as timestamp) > (
                select coalesce(
                    max(source_updated_at),
                    cast('{{ var("initial_watermark", "1900-01-01 00:00:00") }}' as timestamp)
                )
                from {{ state.relation }}
            )
            -- Keep invalid timestamps in the validation input so validation reports them.
            or try_cast(source_updated_at as timestamp) is null
        )
    {% endif %}
{% endmacro %}
