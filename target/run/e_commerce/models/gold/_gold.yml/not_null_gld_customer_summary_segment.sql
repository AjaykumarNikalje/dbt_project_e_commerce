
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select segment
from `retail_analytics_poc`.`dbt_retail_poc`.`gld_customer_summary`
where segment is null



  
  
      
    ) dbt_internal_test