
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select completed_sales_amount
from `retail_analytics_poc`.`dbt_retail_poc`.`gld_customer_summary`
where completed_sales_amount is null



  
  
      
    ) dbt_internal_test