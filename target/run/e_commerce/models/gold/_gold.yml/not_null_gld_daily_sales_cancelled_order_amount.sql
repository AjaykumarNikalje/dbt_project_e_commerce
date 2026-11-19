
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select cancelled_order_amount
from `retail_analytics_poc`.`dbt_retail_poc`.`gld_daily_sales`
where cancelled_order_amount is null



  
  
      
    ) dbt_internal_test