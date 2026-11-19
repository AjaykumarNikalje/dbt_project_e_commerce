
      merge into `retail_analytics_poc`.`dbt_retail_poc`.`dim_customers_scd2` as DBT_INTERNAL_DEST
        using `dim_customers_scd2__dbt_tmp` as DBT_INTERNAL_SOURCE
    on DBT_INTERNAL_SOURCE.`dbt_scd_id` = DBT_INTERNAL_DEST.`dbt_scd_id`
    when matched
        and DBT_INTERNAL_DEST.`dbt_valid_to` is null
        and DBT_INTERNAL_SOURCE.`dbt_change_type` in ('update', 'delete')
        then update
        set `dbt_valid_to` = DBT_INTERNAL_SOURCE.`dbt_valid_to`

    when not matched
        and DBT_INTERNAL_SOURCE.`dbt_change_type` = 'insert'
        then insert (`customer_id`, `customer_name`, `email`, `country`, `segment`, `is_deleted`, `signup_date`, `source_inserted_at`, `source_updated_at`, `brz_ingested_at`, `slr_ingested_at`, `slr_updated_at`, `batch_id`, `operation_type`, `source_file`, `dbt_updated_at`, `dbt_valid_from`, `dbt_valid_to`, `dbt_scd_id`)
        values (`customer_id`, `customer_name`, `email`, `country`, `segment`, `is_deleted`, `signup_date`, `source_inserted_at`, `source_updated_at`, `brz_ingested_at`, `slr_ingested_at`, `slr_updated_at`, `batch_id`, `operation_type`, `source_file`, `dbt_updated_at`, `dbt_valid_from`, `dbt_valid_to`, `dbt_scd_id`)
    ;

  