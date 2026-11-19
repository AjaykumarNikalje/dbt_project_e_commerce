with validated_input as (
    {{ silver_input_customers(ref('brz_customers')) }}
),
ranked_batch as (
    select
        *,
        row_number() over (
            partition by customer_id
            order by source_updated_at desc, brz_ingested_at desc, source_file desc
        ) as row_num
    from validated_input
)

select
    incoming.customer_id,
    incoming.customer_name,
    incoming.email,
    incoming.country,
    incoming.segment,
    incoming.is_deleted,
    incoming.signup_date,
    incoming.source_inserted_at,
    incoming.source_updated_at,
    incoming.brz_ingested_at,
    incoming.slr_ingested_at,
    incoming.slr_updated_at,
    incoming.batch_id,
    incoming.operation_type,
    incoming.source_file
from ranked_batch as incoming
{% if is_incremental() %}
left join {{ this }} as existing
    on incoming.customer_id = existing.customer_id
{% endif %}
where incoming.row_num = 1
{% if is_incremental() %}
  and (existing.customer_id is null
       or incoming.source_updated_at > existing.source_updated_at)
{% endif %}
