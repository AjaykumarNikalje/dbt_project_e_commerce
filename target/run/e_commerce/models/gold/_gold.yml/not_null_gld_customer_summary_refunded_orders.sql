
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select refunded_orders
from `retail_analytics_poc`.`dbt_retail_poc`.`gld_customer_summary`
where refunded_orders is null



  
  
      
    ) dbt_internal_test