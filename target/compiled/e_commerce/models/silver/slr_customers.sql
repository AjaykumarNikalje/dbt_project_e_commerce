with validated_input as (
    
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
from `retail_analytics_poc`.`dbt_retail_poc`.`brz_customers`

    
    
    
        
        
        
    
    
        where (
            try_cast(source_updated_at as timestamp) > (
                select coalesce(
                    max(source_updated_at),
                    cast('1900-01-01 00:00:00' as timestamp)
                )
                from `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers`
            )
            -- Keep invalid timestamps in the validation input so validation reports them.
            or try_cast(source_updated_at as timestamp) is null
        )
    


),
ranked_batch as (
    select
        *,
        row_number() over (
            partition by customer_id
            order by source_updated_at desc, brz_ingested_at desc, source_file desc
        ) as row_num
    from validated_input
)

select
    incoming.customer_id,
    incoming.customer_name,
    incoming.email,
    incoming.country,
    incoming.segment,
    incoming.is_deleted,
    incoming.signup_date,
    incoming.source_inserted_at,
    incoming.source_updated_at,
    incoming.brz_ingested_at,
    incoming.slr_ingested_at,
    incoming.slr_updated_at,
    incoming.batch_id,
    incoming.operation_type,
    incoming.source_file
from ranked_batch as incoming

left join `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers` as existing
    on incoming.customer_id = existing.customer_id

where incoming.row_num = 1

  and (existing.customer_id is null
       or incoming.source_updated_at > existing.source_updated_at)
