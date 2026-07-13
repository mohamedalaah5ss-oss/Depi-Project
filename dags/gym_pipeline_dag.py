import os
import sys
from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator

sys.path.append(os.path.dirname(__file__))

from Data_Cleaning_Script import start_etl_cleaning
from Upload_To_Azure import upload_files_to_azure
from airflow.providers.snowflake.operators.snowflake import SnowflakeOperator

default_args = {
    'owner': 'gym_project_team',
    'depends_on_past': False,
    'start_date': datetime(2026, 7, 5),
    'retries': 1,
    'retry_delay': timedelta(minutes=2),
}

with DAG(
    'gym_complete_data_pipeline',
    default_args=default_args,
    description='End-to-End Gym Pipeline (Python -> Azure -> Snowflake)',
    schedule='@daily',
    catchup=False,
) as dag:

    clean_task = PythonOperator(
        task_id='clean_gym_excel_files',
        python_callable=start_etl_cleaning,
    )

    upload_task = PythonOperator(
        task_id='upload_csv_to_azure',
        python_callable=upload_files_to_azure,
    )

    snowflake_load_task = SnowflakeOperator(
        task_id='copy_data_into_snowflake_tables',
        snowflake_conn_id='snowflake_gym_conn',
        warehouse='COMPUTE_WH',
        database='GYM_DB',
        schema='GYM_SCHEMA',
        sql="""
                COPY INTO GYM_DB.GYM_SCHEMA.customers FROM @gym_azure_stage/Customers.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.employees FROM @gym_azure_stage/Employees.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.geography FROM @gym_azure_stage/Geography.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.product FROM @gym_azure_stage/Product.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.productcosthistory FROM @gym_azure_stage/Productcosthistory.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.productsubcategory FROM @gym_azure_stage/ProductSubcategory.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.region FROM @gym_azure_stage/Region.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.salesdetails FROM @gym_azure_stage/SalesDetails.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.salesheader FROM @gym_azure_stage/SalesHeader.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
                COPY INTO GYM_DB.GYM_SCHEMA.salesreturns FROM @gym_azure_stage/SalesReturns.csv FILE_FORMAT = (TYPE = 'CSV' FIELD_DELIMITER = ',' SKIP_HEADER = 1);
            """,
    )

    clean_task >> upload_task >> snowflake_load_task