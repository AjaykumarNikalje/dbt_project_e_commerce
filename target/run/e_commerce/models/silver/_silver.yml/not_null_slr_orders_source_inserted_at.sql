
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select source_inserted_at
from `retail_analytics_poc`.`dbt_retail_poc`.`slr_orders`
where source_inserted_at is null



  
  
      
    ) dbt_internal_test