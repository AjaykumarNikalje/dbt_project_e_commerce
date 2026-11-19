
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_name
from `retail_analytics_poc`.`dbt_retail_poc`.`gld_customer_summary`
where customer_name is null



  
  
      
    ) dbt_internal_test