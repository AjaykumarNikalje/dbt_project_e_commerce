
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select slr_updated_at
from `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers`
where slr_updated_at is null



  
  
      
    ) dbt_internal_test