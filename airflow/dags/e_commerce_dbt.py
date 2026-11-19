"""Airflow 3 DAG. Configure worker paths and credentials before enabling it."""

from datetime import timedelta

import pendulum
from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import DAG


with DAG(
    dag_id="e_commerce_dbt",
    description="Build and validate the e-commerce dbt pipeline on Databricks.",
    # Manual until the desired schedule is confirmed.
    schedule=None,
    start_date=pendulum.datetime(2026, 11, 15, tz="Asia/Singapore"),
    catchup=False,
    max_active_runs=1,
    is_paused_upon_creation=True,
    dagrun_timeout=timedelta(hours=2),
    tags=["dbt", "databricks", "e_commerce"],
) as dag:
    build = BashOperator(
        task_id="dbt_build",
        bash_command="""
set -euo pipefail
: "${ECOM_DBT_BIN:?Set the absolute path to dbt on the Airflow worker}"
: "${ECOM_DBT_PROJECT_DIR:?Set the project directory on the Airflow worker}"
: "${ECOM_DBT_PROFILES_DIR:?Set the profiles directory on the Airflow worker}"
cd "$ECOM_DBT_PROJECT_DIR"
exec "$ECOM_DBT_BIN" build \
    --project-dir "$ECOM_DBT_PROJECT_DIR" \
    --profiles-dir "$ECOM_DBT_PROFILES_DIR" \
    --target "${ECOM_DBT_TARGET:-dev}" \
    --no-use-colors
""",
        append_env=True,
        do_xcom_push=False,
        execution_timeout=timedelta(minutes=110),
        # Validation failures should be fixed, not automatically retried.
        retries=0,
    )
