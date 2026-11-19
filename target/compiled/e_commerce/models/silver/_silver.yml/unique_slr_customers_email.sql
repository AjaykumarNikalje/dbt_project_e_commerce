
    
    

select
    email as unique_field,
    count(*) as n_records

from `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers`
where email is not null
group by email
having count(*) > 1


