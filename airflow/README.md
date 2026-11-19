Airflow deployment
==================

The DAG targets Airflow 3 with apache-airflow-providers-standard installed.
It is paused and manual-only until the deployment and schedule are confirmed.
It runs one `dbt build` command, preserving dbt's test gates and dependency order.
Only one run of this DAG can be active. Do not run competing manual dbt loads or
other writers against the same tables while it runs.

Provision on every task worker:

1. A checkout/mount of this project and a separate Python 3.11 dbt environment
   with compatible dbt-core 1.12.x and dbt-databricks 1.12.x dependencies.
   A Mac virtual environment cannot be reused in a Linux container.
2. A profiles.yml containing ecommerce_lakehouse_dbt and a target with the intended
   Databricks catalog/schema. Supply credentials through a secret manager or
   worker environment, for example token: "{{ env_var('DATABRICKS_TOKEN') }}".
   Do not include tokens in DAG code, project commits, or Airflow parameters.
3. Worker environment settings:

   ```text
   ECOM_DBT_BIN=/opt/dbt-venv/bin/dbt
   ECOM_DBT_PROJECT_DIR=/opt/dbt/e_commerce
   ECOM_DBT_PROFILES_DIR=/opt/dbt/profiles
   ECOM_DBT_TARGET=dev
   ```

Copy airflow/dags/e_commerce_dbt.py to the deployment's DAG directory. Validate its
import in that Airflow environment, then trigger it manually and inspect the task
log before enabling scheduled runs. In the worker environment, first verify:

```bash
"$ECOM_DBT_BIN" debug --project-dir "$ECOM_DBT_PROJECT_DIR" --profiles-dir "$ECOM_DBT_PROFILES_DIR"
```

For a daily 08:00 Asia/Singapore schedule, replace schedule=None with
schedule="0 8 * * *". The timezone-aware start_date establishes that timezone;
catchup=False avoids historical backfill runs. Confirm the schedule before enabling.

This job does not full-refresh or clean up tables. Data-test failures return a
nonzero exit code and fail the Airflow task; downstream dbt resources are gated
by dbt build. Artifacts and logs live in the project target/ and logs/ directories;
archive them in your deployment if worker storage is ephemeral.
