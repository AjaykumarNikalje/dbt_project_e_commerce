{% macro log_run_start() %}
    {% if execute and var('enable_run_logging', true) %}
        {% do log('Starting e_commerce run | invocation=' ~ invocation_id
            ~ ' | target=' ~ target.name ~ ' | started_at=' ~ run_started_at,
            info=true) %}
    {% endif %}
    {{ return('') }}
{% endmacro %}

{% macro log_run_end(results) %}
    {% if execute and var('enable_run_logging', true) %}
        {% set summary = namespace(errors=0, warnings=0, skipped=0) %}
        {% for result in results %}
            {% set status = result.status | string | lower %}
            {% if status in ['error', 'fail', 'runtime error'] %}
                {% set summary.errors = summary.errors + 1 %}
            {% elif status in ['warn', 'warning'] %}
                {% set summary.warnings = summary.warnings + 1 %}
            {% elif status in ['skip', 'skipped'] %}
                {% set summary.skipped = summary.skipped + 1 %}
            {% endif %}
        {% endfor %}
        {% set overall = 'error' if summary.errors else
            ('warn' if summary.warnings or summary.skipped else 'success') %}
        {% set message = 'Finished e_commerce run | invocation=' ~ invocation_id
            ~ ' | status=' ~ overall ~ ' | results=' ~ (results | length)
            ~ ' | errors=' ~ summary.errors ~ ' | warnings=' ~ summary.warnings
            ~ ' | skipped=' ~ summary.skipped %}
        {% do log(color_run_status(message, overall), info=true) %}
        {% for result in results %}
            {% set message = result.node.unique_id ~ ' | status=' ~ result.status %}
            {% do log(color_run_status(message, result.status), info=true) %}
        {% endfor %}
    {% endif %}
    {{ return('') }}
{% endmacro %}

{% macro color_run_status(message, status) %}
    {% if not flags.USE_COLORS %}
        {{ return(message) }}
    {% endif %}
    {% set status = status | string | lower %}
    {% set escape = '\u001b' %}
    {% if status in ['error', 'fail', 'runtime error'] %}
        {% set color = '31' %}
    {% elif status in ['warn', 'warning', 'skip', 'skipped'] %}
        {% set color = '33' %}
    {% elif status in ['success', 'pass', 'no-op', 'reused'] %}
        {% set color = '32' %}
    {% else %}
        {{ return(message) }}
    {% endif %}
    {{ return(escape ~ '[' ~ color ~ 'm' ~ message ~ escape ~ '[0m') }}
{% endmacro %}
