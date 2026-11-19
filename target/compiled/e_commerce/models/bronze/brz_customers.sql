SELECT
    cast(src_cust.customer_id as string) AS customer_id,
    cast(src_cust.customer_name as string) AS customer_name,
    cast(src_cust.email as string) AS email,
    cast(src_cust.country as string) AS country,
    cast(src_cust.segment as string) AS segment,
    cast(src_cust.signup_date as string) AS signup_date,
    cast(src_cust.source_inserted_at as string) AS source_inserted_at,
    cast(src_cust.source_updated_at as string) AS source_updated_at,
    current_timestamp() AS ingested_at,
    cast(src_cust.batch_id as string) AS batch_id,
    cast(src_cust.operation_type as string) AS operation_type,
    cast(src_cust.source_file as string) AS source_file
FROM `retail_analytics_poc`.`dbt_retail_poc`.`src_customers` AS src_cust


WHERE cast(src_cust.source_updated_at as timestamp) > (
    SELECT coalesce(
        max(cast(source_updated_at as timestamp)),
        cast('1900-01-01 00:00:00' as timestamp)
    )
    FROM `retail_analytics_poc`.`dbt_retail_poc`.`brz_customers`
)
