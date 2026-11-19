
    
    

with all_values as (

    select
        segment as value_field,
        count(*) as n_records

    from `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers`
    group by segment

)

select *
from all_values
where value_field not in (
    'STANDARD','PREMIUM'
)


