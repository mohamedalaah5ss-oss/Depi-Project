import os
import io
import pandas as pd
from dotenv import load_dotenv
from azure.storage.blob import BlobServiceClient

load_dotenv()
AZURE_CONNECTION_STRING = os.getenv("AZURE_CONNECTION_STRING")
CONTAINER_NAME = os.getenv("AZURE_CONTAINER_NAME")

FILES_TO_PROCESS = [
    'Customers', 'Employees', 'Geography', 'Product', 'Productcosthistory',
    'ProductSubcategory', 'Region', 'SalesDetails', 'SalesHeader', 'SalesReturns'
]

def robust_big_data_cleaner(blob_data, file_name):
    try:
        try:
            df = pd.read_csv(io.BytesIO(blob_data))
        except:
            df = pd.read_excel(io.BytesIO(blob_data))
            
        unnamed_cols = [col for col in df.columns if 'Unnamed:' in str(col)]
        if unnamed_cols:
            df.drop(columns=unnamed_cols, inplace=True)
            
        df.drop_duplicates(inplace=True)
        
        for col in df.select_dtypes(include=['object', 'string']).columns:
            df[col] = df[col].astype(str).str.strip()
            
        if file_name == "Customers":
            if 'CustomerName' in df.columns:
                df['CustomerName'] = df['CustomerName'].fillna('Unknown')
        elif file_name in ["SalesHeader", "SalesReturns"]:
            for col in df.columns:
                if 'date' in col.lower():
                    df[col] = pd.to_datetime(df[col], errors='coerce').dt.strftime('%Y-%m-%d')
                    df[col] = df[col].fillna('1900-01-01')
        elif file_name == "Product":
            if 'ListPrice' in df.columns:
                df['ListPrice'] = df['ListPrice'].fillna(0).apply(lambda x: x if x >= 0 else 0)
                
        return df
    except Exception as e:
        print(f"❌ Error cleaning {file_name}: {e}")
        return pd.DataFrame()

def start_cloud_etl():
    print("🚀 Starting Cloud-to-Cloud In-Memory ETL Pipeline...")
    blob_service_client = BlobServiceClient.from_connection_string(AZURE_CONNECTION_STRING)
    
    for file_name in FILES_TO_PROCESS:
        try:
            raw_blob_path = f"raw-data/{file_name}.csv" 
            raw_client = blob_service_client.get_blob_client(container=CONTAINER_NAME, blob=raw_blob_path)
            
            print(f"⬇ Downloading {file_name} to RAM...")
            blob_bytes = raw_client.download_blob().readall()
            
            print(f"🧹 Cleaning {file_name}...")
            df = robust_big_data_cleaner(blob_bytes, file_name)
            
            if df.empty:
                continue
                
            cleaned_blob_path = f"cleaned-data/{file_name}.csv"
            cleaned_client = blob_service_client.get_blob_client(container=CONTAINER_NAME, blob=cleaned_blob_path)
            
            output_csv = df.to_csv(index=False, encoding='utf-8')
            cleaned_client.upload_blob(output_csv, overwrite=True)
            
            print(f"✅ Uploaded clean table to: {cleaned_blob_path}\n")
        except Exception as e:
            print(f"⚠️ Could not process {file_name}: {e}\n")
            
    print("🎉 Cloud ETL Completed Successfully!")

if __name__ == "__main__":
    start_cloud_etl()