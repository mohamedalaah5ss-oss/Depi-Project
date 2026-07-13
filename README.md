# 🏋️‍♂️ End-to-End Cloud Data Pipeline: Gym Management System (DEPI Project)

![Python](https://img.shields.io/badge/Python-3.10-blue?style=for-the-badge&logo=python)
![Azure Blob Storage](https://img.shields.io/badge/Azure-Blob_Storage-0089D6?style=for-the-badge&logo=microsoft-azure)
![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=Apache%20Airflow)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=Snowflake)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker)

## 📌 Project Overview
A robust, cloud-native **End-to-End Data Engineering Pipeline** engineered to ingest, transform, and orchestrate relational data for a Gym Management System. Developed as part of the **Digital Egypt Pioneers Initiative (DEPI)**, this architecture transitions traditional local ETL operations into a high-performance **Cloud-to-Cloud In-Memory ETL pipeline**. 

The system leverages **Azure Blob Storage** as a Medallion-structured Staging Data Lake and **Snowflake** as the enterprise Data Warehouse, fully automated and orchestrated via **Apache Airflow** on **Docker**, culminating in an executive **BI Dashboard**.

---

## 🏛️ Architecture & Data Flow

```text
[ Raw Excel/CSV Sources ] 
         │
         ▼
[ Azure Blob Storage ]  ──(Bronze Layer / raw-data)
         │
         ▼ (In-Memory Stream Processing via io.BytesIO)
[ Python ETL Engine ]   ──(Cleaned & Transformed using Pandas)
         │
         ▼
[ Azure Blob Storage ]  ──(Silver Layer / cleaned-data)
         │
         ▼ (Orchestrated via Airflow & Secured via SAS Token Auth)
[ Snowflake Data Warehouse ] ──(Gold Layer / Star Schema)
         │
         ▼
[ BI Analytics Dashboard ]   ──> Executive KPIs & Reporting

🚀 Key Engineering Highlights
In-Memory Cloud ETL: Eliminated local Disk I/O bottlenecks by downloading raw blob streams directly into RAM (io.BytesIO), applying data cleansing logic via Pandas, and streaming clean CSV outputs directly back to Azure.

Medallion Data Lake Design: Implemented an intra-container storage strategy dividing data into raw-data/ (immutable source lineage) and cleaned-data/ (analytics staging).

Enterprise Security (Zero Trust): Decoupled authentication using Environment Variables (.env) and implemented Shared Access Signature (SAS) Tokens with least-privilege access (Read/List) and strict expiration policies for Snowflake staging.

Containerized Orchestration: Deployed Apache Airflow with a PostgreSQL metadata backend using docker-compose for scheduled, resilient, and automated pipeline execution.

📊 BI Dashboard Preview
(A sneak peek into the executive dashboard built on top of the Snowflake Gold Layer)

🛠️ Project Structure
Bash
├── dags/                  # Airflow DAGs for workflow orchestration
├── src/                   # Core Python ETL and Azure Blob connection scripts
├── dashboards/            # BI report files (Power BI / Tableau)
├── data_samples/          # Lightweight data samples (for schema preview)
├── docs/                  # Architectural diagrams and dashboard screenshots
├── docker-compose.yaml    # Containerized Airflow environment definition
├── requirements.txt       # Project dependencies
└── .env.example           # Environment variables template
⚙️ How to Run Locally
Clone the repository:

Bash
git clone [https://github.com/mohamedalaah5ss-oss/Depi-Project.git](https://github.com/mohamedalaah5ss-oss/Depi-Project.git)
cd Depi-Project
Configure Environment Variables:
Copy the example environment file and populate your Azure and Snowflake credentials:

Bash
cp .env.example .env
Start the Orchestration Environment (Docker):

Bash
docker-compose up -d
Access the Airflow UI at http://localhost:8082 (Default credentials: admin / admin).

Run Standalone Cloud ETL:

Bash
python src/cloud_etl_pipeline.py
🔮 Future Scope
Transition from Pandas to PySpark / Azure Databricks for distributed big data processing.

Migrate the standalone Python transformation script into an event-driven Azure Function (Blob Trigger) for real-time streaming ETL.

Implement Azure Key Vault integration for production-grade secret management.