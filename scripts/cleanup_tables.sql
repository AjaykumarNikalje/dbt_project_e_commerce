-- Creation of the catalog 
CREATE CATALOG IF NOT EXISTS retail_analytics_poc;

-- Development cleanup: drops the project relations and their stored data.
-- Review the catalog/schema below before running in Databricks SQL.
-- Stop dbt jobs first. Run in order: downstream materialized views before tables.
-- Does not drop the catalog/schema, local CSVs, or unrelated tables.

-- Gold aggregates (dropping them also removes their refresh configuration).
DROP MATERIALIZED VIEW IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`gld_customer_summary`;
DROP MATERIALIZED VIEW IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`gld_daily_sales`;

-- Gold dimension and fact.
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`fact_orders`;
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`dim_customers`;

-- Optional: uncomment ONLY if intentionally discarding all customer snapshot history.
-- A later snapshot run starts a new baseline; it cannot restore the old history.
-- DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`dim_customers_scd2`;

-- Silver current-state tables.
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`slr_orders`;
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`slr_customers`;

-- Per-batch staging tables.
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`stg_orders`;
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`stg_customers`;

-- Bronze event history.
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`brz_orders`;
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`brz_customers`;

-- Seed tables in Databricks; local CSV files remain available for dbt seed.
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`src_orders`;
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`src_customers`;

-- Rebuild the current pipeline afterwards from the project terminal:
-- dbt build --exclude resource_type:snapshot
-- If you deliberately reset the snapshot too, establish its new baseline with:
-- dbt snapshot --select dim_customers_scd2
DROP TABLE IF EXISTS `retail_analytics_poc`.`dbt_retail_poc`.`dim_customers_scd2`;
