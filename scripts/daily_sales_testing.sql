Select 
cast(source_inserted_at as date) order_date,
sum(case when fo.order_id is not null then 1 else 0 end) as total_orders, 
sum(case when fo.status = 'PLACED' then 1 else 0 end) as placed_orders,
sum(case when fo.status = 'COMPLETED' then 1 else 0 end) as completed_orders,
sum( case when fo.status='COMPLETED' then fo.amount else 0 END ) as completed_sales_amount,
sum(case when fo.status = 'CANCELLED' then 1 else 0 end) as cancelled_orders,
sum( case when fo.status='CANCELLED' then fo.amount else 0 END ) as cancelled_order_amount,
sum(case when fo.status = 'REFUNDED' then 1 else 0 end) as refunded_orders,
sum( case when fo.status='REFUNDED' then fo.amount else 0 END ) as refunded_order_amount
from retail_analytics_poc.dbt_retail_poc.fact_orders fo 
group by cast(source_inserted_at as date)