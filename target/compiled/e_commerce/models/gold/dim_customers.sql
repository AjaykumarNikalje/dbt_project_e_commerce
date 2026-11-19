
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
from `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers`

    
    
    
        
        
        
    
    
        where (
            slr_updated_at >= (
                select coalesce(max(slr_updated_at),
                    cast('1900-01-01 00:00:00' as timestamp))
                from `retail_analytics_poc`.`dbt_retail_poc`.`dim_customers`
            )
            or slr_updated_at is null
        )
    

