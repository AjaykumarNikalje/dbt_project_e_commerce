
    with incoming as (
        
            
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
                
                , case when `slr_updated_at` is null
                    then 'slr_updated_at: required value missing or cast failed' end
                
                
                , case when `segment` is not null
                    and `segment` not in (
                        
                        'STANDARD',
                        
                        'PREMIUM'
                        
                    ) then 'segment: value outside allowed list' end
                
                
            ) as validation_errors
        from incoming
    )
    select * from validation
    where validation_errors <> ''
