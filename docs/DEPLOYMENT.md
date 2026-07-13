# Deployment & Installation Guide

This guide covers the full setup process for running the pipeline locally and connecting to Azure and Snowflake cloud services.

---

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Python | ≥ 3.9 | ETL script and Airflow |
| Docker & Docker Compose | Latest | Local Airflow environment |
| Azure Storage Account | — | Bronze & Silver blob layers |
| Snowflake Account | — | Gold layer data warehouse |
| Power BI Desktop | Latest | Dashboard visualization |

---

## 1. Clone the Repository

```bash
git clone https://github.com/mohamedalaah5ss-oss/Depi-Project.git
cd Depi-Project
```

---

## 2. Configure Environment Variables

Copy the example file and fill in your credentials:

```bash
cp .env.example .env
```

Open `.env` and populate:

```env
# Azure Blob Storage
AZURE_STORAGE_ACCOUNT_NAME=your_account_name
AZURE_SAS_TOKEN=your_sas_token
AZURE_CONTAINER_BRONZE=bronze
AZURE_CONTAINER_SILVER=silver

# Snowflake
SNOWFLAKE_ACCOUNT=your_account_identifier
SNOWFLAKE_USER=your_username
SNOWFLAKE_PASSWORD=your_password
SNOWFLAKE_WAREHOUSE=your_warehouse
SNOWFLAKE_DATABASE=GYM_DB
SNOWFLAKE_SCHEMA=GOLD
```

> ⚠️ **Never commit your `.env` file.** It is listed in `.gitignore`.

---

## 3. Azure Blob Storage Setup

1. In the Azure Portal, create a **Storage Account**.
2. Create two containers: `bronze` and `silver`.
3. Generate a **SAS token** for each container with:
   - Permissions: Read, Write, List
   - Expiry: set appropriately for your testing window
4. Copy the SAS token value into `.env`.

> **Why SAS tokens?** SAS tokens follow the least-privilege principle — they grant time-limited, scope-limited access without exposing the full storage account key.

---

## 4. Snowflake Setup

1. Create a Snowflake account (free trial available at [snowflake.com](https://www.snowflake.com)).
2. Create a database named `GYM_DB` and a schema named `GOLD`.
3. Create a warehouse (e.g., `COMPUTE_WH`, X-Small size is sufficient).
4. Run the DDL scripts in `sql/` to create the Star Schema tables:

```bash
# Connect via SnowSQL or the Snowflake web UI
# Run: sql/create_schema.sql
```

---

## 5. Run Airflow with Docker

```bash
docker-compose up -d
```

Access the Airflow UI:
- URL: `http://localhost:8082`
- Username: `admin`
- Password: `admin`

Enable and trigger the DAG: `gym_complete_data_pipeline`

---

## 6. Run the ETL Script Manually (Optional)

To run the pipeline outside of Airflow:

```bash
pip install -r requirements.txt
python src/cloud_etl_pipeline.py
```

---

## 7. Power BI Dashboard

1. Open `dashboards/gym_sales_dashboard.pbix` in Power BI Desktop.
2. Update the Snowflake connection string to point to your account.
3. Refresh the data model.

---

## Troubleshooting

| Issue | Likely Cause | Fix |
|-------|-------------|-----|
| Airflow UI not loading | Docker not running | Run `docker-compose up -d` |
| Azure upload fails | Invalid or expired SAS token | Regenerate SAS token in Azure Portal |
| Snowflake connection error | Wrong account identifier | Use format `orgname-accountname` |
| Power BI blank visuals | Snowflake credentials not set | Update data source settings in Power BI |
