
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select dim_ingested_time
from `retail_analytics_poc`.`dbt_retail_poc`.`dim_customers`
where dim_ingested_time is null



  
  
      
    ) dbt_internal_test