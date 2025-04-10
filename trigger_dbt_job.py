from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.providers.dbt.cloud.operators.dbt import DbtCloudJobRunOperator
from airflow.hooks.postgres_hook import PostgresHook
import pandas as pd
from datetime import datetime, timedelta
from io import BytesIO
import logging
from google.cloud import storage

# Function to read data from GCS and load into Postgres
def load_data_from_gcs_to_postgres(bucket_name, object_name, table_name):
    logging.info(f"Starting to load {object_name} from bucket {bucket_name} into table {table_name}")
    try:
        # Set up the GCS client
        client = storage.Client()
        bucket = client.get_bucket(bucket_name)
        blob = bucket.blob(object_name)

        # Download the data as a stream of bytes
        data = blob.download_as_bytes()
        logging.info(f"Downloaded {object_name} successfully from {bucket_name}")

        # Read the data into a Pandas DataFrame directly from the bytes
        df = pd.read_csv(BytesIO(data))
        logging.info(f"Data read into DataFrame for table {table_name}, shape: {df.shape}")

        # Use PostgresHook to get the connection and engine
        pg_hook = PostgresHook(postgres_conn_id='postgres')
        engine = pg_hook.get_sqlalchemy_engine()

        # Load the data into Postgres table
        df.to_sql(table_name, engine, schema='bronze', if_exists='append', index=False)
        logging.info(f"Successfully loaded data into {table_name}")
    except Exception as e:
        logging.error(f"Error loading {object_name} from bucket {bucket_name} to Postgres: {str(e)}")
        raise

# Define the DAG
default_args = {
    'owner': 'airflow',
    'start_date': datetime(2024, 11, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    dag_id='load_and_transform_airbnb_data',
    default_args=default_args,
    schedule_interval=None,
    catchup=False,
) as dag:

    # List of filenames in chronological order
    data_files = [
        '06_2020.csv',
        '07_2020.csv',
        '08_2020.csv',
        '09_2020.csv',
        '10_2020.csv',
        '11_2020.csv',
        '12_2020.csv',
        '01_2021.csv',
        '02_2021.csv',
        '03_2021.csv',
        '04_2021.csv'
    ]

    # Task generator for each month's data
    previous_task = None
    for data_file in data_files:
        task_id = f"load_{data_file.split('/')[-1].split('.')[0]}_to_postgres"
        load_task = PythonOperator(
            task_id=task_id,
            python_callable=load_data_from_gcs_to_postgres,
            op_kwargs={
                'bucket_name': 'australia-southeast1-airbnb-5672f4da-bucket',
                'object_name': data_file,
                'table_name': 'airbnb_raw'
            }
        )

        # Chain tasks sequentially
        if previous_task:
            previous_task >> load_task
        previous_task = load_task

    # Task to trigger the dbt Cloud job
    dbt_job_run = DbtCloudJobRunOperator(
        task_id='trigger_dbt_job',
        dbt_cloud_conn_id='my_dbt_cloud',  # Ensure this connection is set up in Airflow
        job_id=70403104223734  # Replace with your actual dbt job ID from dbt Cloud
    )

    # Set the dbt job to run after all data loading tasks are completed
    previous_task >> dbt_job_run
