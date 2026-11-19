
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    with incoming as (
        
            
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
from `retail_analytics_poc`.`dbt_retail_poc`.`brz_orders`

    
    
    
        
        
        
    
    
        where (
            try_cast(source_updated_at as timestamp) > (
                select coalesce(
                    max(source_updated_at),
                    cast('1900-01-01 00:00:00' as timestamp)
                )
                from `retail_analytics_poc`.`dbt_retail_poc`.`slr_orders`
            )
            -- Keep invalid timestamps in the validation input so validation reports them.
            or try_cast(source_updated_at as timestamp) is null
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
                
                , case when `brz_ingested_at` is null
                    then 'brz_ingested_at: required value missing or cast failed' end
                
                , case when `slr_ingested_at` is null
                    then 'slr_ingested_at: required value missing or cast failed' end
                
                , case when `slr_updated_at` is null
                    then 'slr_updated_at: required value missing or cast failed' end
                
                , case when `batch_id` is null
                    then 'batch_id: required value missing or cast failed' end
                
                , case when `operation_type` is null
                    then 'operation_type: required value missing or cast failed' end
                
                , case when `source_file` is null
                    then 'source_file: required value missing or cast failed' end
                
                
                , case when `status` is not null
                    and `status` not in (
                        
                        'PLACED',
                        
                        'COMPLETED',
                        
                        'CANCELLED',
                        
                        'REFUNDED'
                        
                    ) then 'status: value outside allowed list' end
                
                , case when `operation_type` is not null
                    and `operation_type` not in (
                        
                        'INSERT',
                        
                        'UPDATE'
                        
                    ) then 'operation_type: value outside allowed list' end
                
                
                , case when `amount` < 0
                    or `amount` > 100000
                    then 'amount: value outside allowed range' end
                
            ) as validation_errors
        from incoming
    )
    select * from validation
    where validation_errors <> ''

  
  
      
    ) dbt_internal_test