-- back compat for old kwarg name
  
  
  
  
  
  
      
          
          
      
  

    merge
    into
        `retail_analytics_poc`.`dbt_retail_poc`.`fact_orders` as DBT_INTERNAL_DEST
    using
        `fact_orders__dbt_tmp` as DBT_INTERNAL_SOURCE
    on
        
              DBT_INTERNAL_SOURCE.`order_id` <=> DBT_INTERNAL_DEST.`order_id`
          
    when matched
        then update set
            `order_id` = DBT_INTERNAL_SOURCE.`order_id`, `customer_id` = DBT_INTERNAL_SOURCE.`customer_id`, `amount` = DBT_INTERNAL_SOURCE.`amount`, `status` = DBT_INTERNAL_SOURCE.`status`, `source_inserted_at` = DBT_INTERNAL_SOURCE.`source_inserted_at`, `source_updated_at` = DBT_INTERNAL_SOURCE.`source_updated_at`, `slr_updated_at` = DBT_INTERNAL_SOURCE.`slr_updated_at`
    when not matched
        then insert
            (`order_id`, `customer_id`, `amount`, `status`, `source_inserted_at`, `source_updated_at`, `slr_updated_at`) VALUES (DBT_INTERNAL_SOURCE.`order_id`, DBT_INTERNAL_SOURCE.`customer_id`, DBT_INTERNAL_SOURCE.`amount`, DBT_INTERNAL_SOURCE.`status`, DBT_INTERNAL_SOURCE.`source_inserted_at`, DBT_INTERNAL_SOURCE.`source_updated_at`, DBT_INTERNAL_SOURCE.`slr_updated_at`)
