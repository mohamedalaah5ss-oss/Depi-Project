<div align="center">

# 🏋️‍♂️ End-to-End Cloud Data Pipeline
### Gym Management Analytics System

**A cloud-native, in-memory ETL pipeline built on a Medallion architecture — streaming raw gym data through Azure Blob Storage and Snowflake into an executive BI dashboard.**

![Python](https://img.shields.io/badge/Python-3.10-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Azure Blob Storage](https://img.shields.io/badge/Azure-Blob_Storage-0089D6?style=for-the-badge&logo=microsoft-azure&logoColor=white)
![Apache Airflow](https://img.shields.io/badge/Apache%20Airflow-017CEE?style=for-the-badge&logo=apacheairflow&logoColor=white)
![Snowflake](https://img.shields.io/badge/Snowflake-29B5E8?style=for-the-badge&logo=snowflake&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey?style=for-the-badge)

</div>

---

## 📌 Project Overview

A robust, cloud-native **End-to-End Data Engineering Pipeline** engineered to ingest, transform, and orchestrate relational data for a Gym Management System. Developed as part of the **Digital Egypt Pioneers Initiative (DEPI)**, this architecture transitions traditional local ETL operations into a high-performance **cloud-to-cloud, in-memory ETL pipeline**.

The system leverages **Azure Blob Storage** as a Medallion-structured staging data lake and **Snowflake** as the enterprise data warehouse — fully automated and orchestrated via **Apache Airflow** on **Docker**, culminating in an executive **Power BI dashboard**.

---

## 🚀 Project Highlights

- ⚡ **In-Memory Cloud ETL** — eliminates local disk I/O bottlenecks by streaming raw blobs directly into memory (`io.BytesIO`), cleansing with Pandas, and writing clean CSV output straight back to Azure
- 🥉🥈🥇 **Medallion Data Lake Design** — data separated into `raw-data/` (immutable source lineage) and `cleaned-data/` (analytics staging), feeding a Snowflake Gold-layer star schema
- 🔐 **Zero-Trust Security** — credentials decoupled via environment variables (`.env`), with Snowflake staging secured through least-privilege, time-boxed **SAS tokens**
- 🐳 **Containerized Orchestration** — Apache Airflow deployed with a PostgreSQL metadata backend via `docker-compose`, for scheduled, resilient, automated pipeline runs
- 📊 **Executive BI Reporting** — Snowflake Gold-layer data feeds a multi-page Power BI dashboard for business-ready insights

---

## 🏛️ Architecture & Data Flow

```text
[ Raw Excel/CSV Sources ]
         │
         ▼
┌───────────────────────────────────────────────────────────────┐
│      Apache Airflow  ──  DAG: gym_complete_data_pipeline       │
│                                                                 │
│   clean_gym_excel_files → upload_csv_to_azure →                │
│                              copy_data_into_snowflake_tables    │
│                                                                 │
│  [ Azure Blob Storage ]        ── Bronze Layer  (raw-data/)    │
│           │                                                    │
│           ▼  (in-memory stream processing via io.BytesIO)      │
│  [ Python ETL Engine ]         ── Cleaned & transformed         │
│           │                       with Pandas                  │
│           ▼                                                    │
│  [ Azure Blob Storage ]        ── Silver Layer (cleaned-data/) │
│           │                                                    │
│           ▼  (secured via SAS token auth)                      │
│  [ Snowflake Data Warehouse ]  ── Gold Layer (Star Schema)     │
└───────────────────────────────────────────────────────────────┘
         │
         ▼
[ Power BI Dashboard ]        ── Executive KPIs & Reporting
```

---

## ⚙️ Apache Airflow Orchestration

The entire pipeline is automated end-to-end by a single Airflow DAG, running on a `@daily` schedule inside Docker.

<div align="center">

| | |
|---|---|
| **DAG ID** | `gym_complete_data_pipeline` |
| **Description** | End-to-End Gym Pipeline (Python → Azure → Snowflake) |
| **Schedule** | `@daily` |
| **Total Tasks** | 3 |

</div>

The DAG executes three sequential tasks, each mapping to a stage of the Medallion pipeline:

| Order | Task ID | Responsibility |
|:---:|---|---|
| 1 | `clean_gym_excel_files` | Reads raw Excel sources and produces cleaned, validated data |
| 2 | `upload_csv_to_azure` | Streams cleaned data into Azure Blob Storage (Silver layer) |
| 3 | `copy_data_into_snowflake_tables` | Loads staged data into Snowflake (Gold layer) |

<div align="center">
<img src="docs/images/airflow_pipeline_success.png" alt="Airflow Pipeline Success" width="850"/>
<br><sub>Successful DAG run — all three tasks completed with a total run duration of ~18 seconds.</sub>
</div>

---

## 🧰 Technology Stack

<div align="center">

| Layer | Technology |
|---|---|
| **Language** | Python, SQL |
| **Data Processing** | Pandas (in-memory, stream-based) |
| **Cloud Storage** | Azure Blob Storage (Medallion: raw-data / cleaned-data) |
| **Cloud Data Warehouse** | Snowflake (Star Schema) |
| **Security** | SAS Tokens, Environment Variables (`.env`) |
| **Orchestration** | Apache Airflow |
| **Containerization** | Docker / Docker Compose |
| **Metadata Store** | PostgreSQL |
| **Business Intelligence** | Power BI |
| **Version Control** | Git, GitHub |

</div>

---

## 📊 BI Dashboard Preview

<details open>
<summary><strong>Click to view the executive dashboard gallery</strong></summary>

Built on top of the Snowflake Gold Layer, the dashboard is organized into six focused report pages:

**Overview**
<br>Executive summary of revenue, profit, cost, and GM% across the business.
<div align="center"><img src="docs/images/dashboard_overview.png" alt="Overview Dashboard" width="800"/></div>

**Employees Performance**
<br>Sales performance and productivity breakdown by employee.
<div align="center"><img src="docs/images/dashboard_employees_performance.png" alt="Employees Performance Dashboard" width="800"/></div>

**Customers Analysis**
<br>Customer segmentation and purchasing behavior insights.
<div align="center"><img src="docs/images/dashboard_customers_analysis.png" alt="Customers Analysis Dashboard" width="800"/></div>

**Product Analysis**
<br>Top-performing products and subcategory-level trends.
<div align="center"><img src="docs/images/dashboard_product_analysis.png" alt="Product Analysis Dashboard" width="800"/></div>

**Time Analysis**
<br>Sales trends and seasonality across time periods.
<div align="center"><img src="docs/images/dashboard_time_analysis.png" alt="Time Analysis Dashboard" width="800"/></div>

**Returns Analysis**
<br>Return rates and their impact on revenue and profitability.
<div align="center"><img src="docs/images/dashboard_returns_analysis.png" alt="Returns Analysis Dashboard" width="800"/></div>

</details>

---

## 🖼️ Pipeline Screenshots

<details>
<summary><strong>🏛️ Architecture &nbsp;•&nbsp; ⚙️ Airflow &nbsp;•&nbsp; 🐳 Docker &nbsp;•&nbsp; ❄️ Snowflake</strong></summary>

| Architecture Diagram | Airflow DAG List |
|---|---|
| ![Architecture](docs/images/project_architecture.png) | ![Airflow DAG](docs/images/airflow_dag_list.png) |

| Docker Containers |
|---|
| ![Docker Containers](docs/images/docker_containers.png) |

> ℹ️ The Airflow pipeline success screenshot is featured in the [Apache Airflow Orchestration](#️-apache-airflow-orchestration) section above.

<div align="center">
<img src="docs/images/snowflake_stage_creation.png" alt="Snowflake Stage Creation" width="800"/>
</div>

</details>

---

## 📂 Project Structure

```text
Depi-Project/
│
├── dags/                  # Airflow DAGs for workflow orchestration
├── src/                   # Core Python ETL and Azure Blob connection scripts
├── sql/                   # SQL DDL and transformation scripts
├── dashboards/            # Power BI report files
├── Data_Set/              # Original raw source data
├── Cleaned_Data/          # Cleaned, pipeline-ready output data
├── docs/                  # Architecture diagrams and dashboard screenshots
├── docker-compose.yaml    # Containerized Airflow environment definition
├── requirements.txt       # Project dependencies
├── .env.example           # Environment variables template
├── .gitignore             # Files and folders excluded from version control
└── LICENSE                # MIT License
```

---

## ⚙️ How to Run Locally

**1. Clone the repository**
```bash
git clone https://github.com/mohamedalaah5ss-oss/Depi-Project.git
cd Depi-Project
```

**2. Configure environment variables**

Copy the example environment file and populate your Azure and Snowflake credentials:
```bash
cp .env.example .env
```

**3. Start the orchestration environment (Docker)**
```bash
docker-compose up -d
```
Access the Airflow UI at `http://localhost:8082` (default credentials: `admin` / `admin`).

**4. Run the standalone cloud ETL (optional, outside Airflow)**
```bash
python src/cloud_etl_pipeline.py
```

---

## 🔮 Future Scope

- 🔄 **Incremental Data Loading** — load only new or changed records instead of full refreshes
- ✅ **Data Quality Validation** — automated checks between pipeline stages
- 🧩 **Pipeline Parameterization** — configurable DAG runs for multiple environments
- 🔐 **Azure Key Vault Integration** — production-grade, centralized secret management
- ⚡ **Performance Optimization** — tuning Snowflake warehouse sizing and query performance

---

## 👤 Author

**Mohamed Alaa**
Data Engineering Graduate Project — Digital Egypt Pioneers Initiative (DEPI)

[![GitHub](https://img.shields.io/badge/GitHub-Profile-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/mohamedalaah5ss-oss)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/mohammed-alaa-engineer/)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙏 Acknowledgments

- **Digital Egypt Pioneers Initiative (DEPI)** — for program guidance and mentorship
- **Apache Airflow**, **Snowflake**, and **Microsoft Azure** documentation communities
