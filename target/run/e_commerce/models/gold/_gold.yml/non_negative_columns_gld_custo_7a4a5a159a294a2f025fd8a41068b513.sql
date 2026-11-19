
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    select *
    from `retail_analytics_poc`.`dbt_retail_poc`.`gld_customer_summary`
    where
        
        `total_orders` < 0 or
        
        `completed_orders` < 0 or
        
        `completed_sales_amount` < 0 or
        
        `cancelled_orders` < 0 or
        
        `refunded_orders` < 0
        

  
  
      
    ) dbt_internal_test