
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select status
from `retail_analytics_poc`.`dbt_retail_poc`.`fact_orders`
where status is null



  
  
      
    ) dbt_internal_test