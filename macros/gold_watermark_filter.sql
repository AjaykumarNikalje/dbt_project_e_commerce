{% macro gold_watermark_filter(model_name) %}
    {# Avoid a ref() cycle: Silver test reads existing Gold state only. #}
    {% set state = namespace(relation=none) %}
    {% if execute and not flags.FULL_REFRESH %}
        {% set node = graph.nodes.get('model.' ~ project_name ~ '.' ~ model_name) %}
        {% if node is none %}
            {{ exceptions.raise_compiler_error('Unknown Gold model: ' ~ model_name) }}
        {% endif %}
        {% set state.relation = adapter.get_relation(
            database=node.database, schema=node.schema, identifier=node.alias) %}
    {% endif %}
    {% if state.relation is not none %}
        where (
            slr_updated_at >= (
                select coalesce(max(slr_updated_at),
                    cast('{{ var("initial_watermark", "1900-01-01 00:00:00") }}' as timestamp))
                from {{ state.relation }}
            )
            or slr_updated_at is null
        )
    {% endif %}
{% endmacro %}
