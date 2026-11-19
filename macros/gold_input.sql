{% macro gold_input_dim_customers(silver_relation) %}
select
    customer_id,
    customer_name,
    email,
    country,
    segment,
    signup_date,
    is_deleted,
    slr_updated_at,
    current_timestamp() as dim_ingested_time,
    current_timestamp() as dim_updated_time
from {{ silver_relation }}
{{ gold_watermark_filter('dim_customers') }}
{% endmacro %}

{% macro gold_input_fact_orders(silver_relation) %}
select
    order_id,
    customer_id,
    amount,
    status,
    source_inserted_at,
    source_updated_at,
    slr_updated_at
from {{ silver_relation }}
{{ gold_watermark_filter('fact_orders') }}
{% endmacro %}
