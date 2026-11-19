
select
    order_id,
    customer_id,
    amount,
    status,
    source_inserted_at,
    source_updated_at,
    slr_updated_at
from `retail_analytics_poc`.`dbt_retail_poc`.`slr_orders`

    
    
    
        
        
        
    
    
        where (
            slr_updated_at >= (
                select coalesce(max(slr_updated_at),
                    cast('1900-01-01 00:00:00' as timestamp))
                from `retail_analytics_poc`.`dbt_retail_poc`.`fact_orders`
            )
            or slr_updated_at is null
        )
    

