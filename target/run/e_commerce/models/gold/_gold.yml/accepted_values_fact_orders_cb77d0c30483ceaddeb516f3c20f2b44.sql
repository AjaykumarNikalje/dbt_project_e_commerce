
    
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from `retail_analytics_poc`.`dbt_retail_poc`.`fact_orders`
    group by status

)

select *
from all_values
where value_field not in (
    'PLACED','COMPLETED','CANCELLED','REFUNDED'
)



  
  
      
    ) dbt_internal_test