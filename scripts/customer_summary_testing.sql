select dc.customer_id, dc.customer_name, dc.country, dc.segment, 
sum(case when fo.order_id is not null then 1 else 0 end) as total_orders, 
sum(case when fo.status = 'COMPLETED' then 1 else 0 end) as completed_orders,
sum( case when fo.status='COMPLETED' then fo.amount else 0 END ) as completed_sales_amount,
sum(case when fo.status = 'CANCELLED' then 1 else 0 end) as cancelled_orders,
sum(case when fo.status = 'REFUNDED' then 1 else 0 end) as refunded_orders,
max(source_inserted_at) as latest_order_at
from retail_analytics_poc.dbt_retail_poc.dim_customers dc 
left join retail_analytics_poc.dbt_retail_poc.fact_orders fo 
on dc.customer_id = fo.customer_id
group by dc.customer_id, dc.customer_name, dc.country, dc.segment
order by dc.customer_id