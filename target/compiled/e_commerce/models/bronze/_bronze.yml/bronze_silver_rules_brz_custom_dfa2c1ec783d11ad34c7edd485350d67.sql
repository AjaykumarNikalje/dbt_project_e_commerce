
    with incoming as (
        
            
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
    validation as (
        select
            *,
            concat_ws('; ',
                ''
                
                , case when `customer_id` is null
                    then 'customer_id: required value missing or cast failed' end
                
                , case when `customer_name` is null
                    then 'customer_name: required value missing or cast failed' end
                
                , case when `email` is null
                    then 'email: required value missing or cast failed' end
                
                , case when `country` is null
                    then 'country: required value missing or cast failed' end
                
                , case when `segment` is null
                    then 'segment: required value missing or cast failed' end
                
                , case when `signup_date` is null
                    then 'signup_date: required value missing or cast failed' end
                
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
                
                , case when `operation_type` is null
                    then 'operation_type: required value missing or cast failed' end
                
                , case when `source_file` is null
                    then 'source_file: required value missing or cast failed' end
                
                
                , case when `segment` is not null
                    and `segment` not in (
                        
                        'STANDARD',
                        
                        'PREMIUM'
                        
                    ) then 'segment: value outside allowed list' end
                
                , case when `operation_type` is not null
                    and `operation_type` not in (
                        
                        'INSERT',
                        
                        'UPDATE',
                        
                        'DELETE'
                        
                    ) then 'operation_type: value outside allowed list' end
                
                
            ) as validation_errors
        from incoming
    )
    select * from validation
    where validation_errors <> ''
