
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from `retail_analytics_poc`.`dbt_retail_poc`.`slr_orders`
    group by status

)

select *
from all_values
where value_field not in (
    'PLACED','COMPLETED','CANCELLED','REFUNDED'
)


