
    
    

with all_values as (

    select
        operation_type as value_field,
        count(*) as n_records

    from `retail_analytics_poc`.`dbt_retail_poc`.`slr_orders`
    group by operation_type

)

select *
from all_values
where value_field not in (
    'INSERT','UPDATE'
)


