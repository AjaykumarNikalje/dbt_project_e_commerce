SELECT
    cast(src_ord.order_id as string) AS order_id,
    cast(src_ord.customer_id as string) AS customer_id,
    cast(src_ord.amount as string) AS amount,
    cast(src_ord.status as string) AS status,
    cast(src_ord.source_inserted_at as string) AS source_inserted_at,
    cast(src_ord.source_updated_at as string) AS source_updated_at,
    current_timestamp() AS ingested_at,
    cast(src_ord.batch_id as string) AS batch_id,
    cast(src_ord.operation_type as string) AS operation_type,
    cast(src_ord.source_file as string) AS source_file
FROM {{ ref('src_orders') }} AS src_ord

{% if is_incremental() %}
WHERE cast(src_ord.source_updated_at as timestamp) > (
    SELECT coalesce(
        max(cast(source_updated_at as timestamp)),
        cast('{{ var("initial_watermark", "1900-01-01 00:00:00") }}' as timestamp)
    )
    FROM {{ this }}
)
{% endif %}
