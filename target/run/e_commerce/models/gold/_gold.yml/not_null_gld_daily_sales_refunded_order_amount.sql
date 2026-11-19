
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select refunded_order_amount
from `retail_analytics_poc`.`dbt_retail_poc`.`gld_daily_sales`
where refunded_order_amount is null



  
  
      
    ) dbt_internal_test