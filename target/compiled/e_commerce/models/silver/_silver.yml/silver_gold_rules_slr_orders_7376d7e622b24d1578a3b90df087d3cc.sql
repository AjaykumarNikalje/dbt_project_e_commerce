
    with incoming as (
        
            
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
    


        
    ),
    validation as (
        select
            *,
            concat_ws('; ',
                ''
                
                , case when `order_id` is null
                    then 'order_id: required value missing or cast failed' end
                
                , case when `customer_id` is null
                    then 'customer_id: required value missing or cast failed' end
                
                , case when `amount` is null
                    then 'amount: required value missing or cast failed' end
                
                , case when `status` is null
                    then 'status: required value missing or cast failed' end
                
                , case when `source_inserted_at` is null
                    then 'source_inserted_at: required value missing or cast failed' end
                
                , case when `source_updated_at` is null
                    then 'source_updated_at: required value missing or cast failed' end
                
                , case when `slr_updated_at` is null
                    then 'slr_updated_at: required value missing or cast failed' end
                
                
                , case when `status` is not null
                    and `status` not in (
                        
                        'PLACED',
                        
                        'COMPLETED',
                        
                        'CANCELLED',
                        
                        'REFUNDED'
                        
                    ) then 'status: value outside allowed list' end
                
                
                , case when `amount` < 0
                    or `amount` > 100000
                    then 'amount: value outside allowed range' end
                
            ) as validation_errors
        from incoming
    )
    select * from validation
    where validation_errors <> ''
