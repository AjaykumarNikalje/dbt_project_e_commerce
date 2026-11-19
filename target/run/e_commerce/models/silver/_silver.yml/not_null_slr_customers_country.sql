
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select country
from `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers`
where country is null



  
  
      
    ) dbt_internal_test