
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from `retail_analytics_poc`.`dbt_retail_poc`.`gld_customer_summary`
where customer_id is not null
group by customer_id
having count(*) > 1


