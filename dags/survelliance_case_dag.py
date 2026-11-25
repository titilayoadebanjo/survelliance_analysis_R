from airflow import DAG

from airflow.operators.bash import BashOperator

from datetime import datetime


with DAG(

    dag_id="surveillance_pipeline",

    start_date=datetime(
        2026,
        1,
        1
    ),

    schedule="@daily",

    catchup=False,

    tags=["personal", "surveillance"]

) as dag:

    run_pipeline = BashOperator(

        task_id="run_surveillance_pipeline",

        bash_command="""
        python /app/src/main.py
        """

    )

    run_pipeline