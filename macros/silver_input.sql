{% macro silver_input_customers(bronze_relation) %}
select
    try_cast(customer_id as int) as customer_id,
    customer_name,
    email,
    country,
    segment,
    try_cast(signup_date as date) as signup_date,
    try_cast(source_inserted_at as timestamp) as source_inserted_at,
    try_cast(source_updated_at as timestamp) as source_updated_at,
    ingested_at as brz_ingested_at,
    current_timestamp() as slr_ingested_at,
    current_timestamp() as slr_updated_at,
    operation_type = 'DELETE' as is_deleted,
    batch_id,
    operation_type,
    source_file
from {{ bronze_relation }}
{{ silver_watermark_filter('slr_customers') }}
{% endmacro %}

{% macro silver_input_orders(bronze_relation) %}
select
    try_cast(order_id as int) as order_id,
    try_cast(customer_id as int) as customer_id,
    try_cast(amount as decimal(18,2)) as amount,
    status,
    try_cast(source_inserted_at as timestamp) as source_inserted_at,
    try_cast(source_updated_at as timestamp) as source_updated_at,
    ingested_at as brz_ingested_at,
    current_timestamp() as slr_ingested_at,
    current_timestamp() as slr_updated_at,
    batch_id,
    operation_type,
    source_file
from {{ bronze_relation }}
{{ silver_watermark_filter('slr_orders') }}
{% endmacro %}
