
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select source_file
from `retail_analytics_poc`.`dbt_retail_poc`.`slr_orders`
where source_file is null



  
  
      
    ) dbt_internal_test