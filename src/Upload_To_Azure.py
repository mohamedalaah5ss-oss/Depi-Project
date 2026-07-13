import os
from azure.storage.blob import BlobServiceClient

LOCAL_CSV_DIR = r"C:\Users\Zbook G6\Desktop\Graduation_Project\CleanedData"
CONTAINER_NAME = "raw-gym-data"

AZURE_CONNECTION_STRING = r"DefaultEndpointsProtocol=https;..."


def upload_files_to_azure():

    try:
        print(" Connecting to Azure Blob Storage...")
        blob_service_client = BlobServiceClient.from_connection_string(AZURE_CONNECTION_STRING)
        container_client = blob_service_client.get_container_client(CONTAINER_NAME)

        if not container_client.exists():
            container_client.create_container()
            print(f" Created new container named: {CONTAINER_NAME}")

        print(" Uploading cleaned files to the cloud...")

        for file_name in os.listdir(LOCAL_CSV_DIR):
            if file_name.endswith('.csv'):
                local_file_path = os.path.join(LOCAL_CSV_DIR, file_name)
                blob_client = blob_service_client.get_blob_client(container=CONTAINER_NAME, blob=file_name)

                print(f"⬆ Uploading: {file_name}...")
                with open(local_file_path, "rb") as data:
                    blob_client.upload_blob(data, overwrite=True)
                print(f"✅ Uploaded {file_name} successfully!")

        print("🎉 Success! All files are uploaded to Azure and ready for the next phase.")
    except Exception as e:
        print(f"❌ Error occurred during upload: {e}")


if __name__ == "__main__":
    upload_files_to_azure()