# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-07-14

### Added
- End-to-end Medallion pipeline: Bronze → Silver (Azure Blob Storage) → Gold (Snowflake)
- Airflow DAG `gym_complete_data_pipeline` with 3 orchestrated tasks
- Snowflake Star Schema: `fact_sales`, `dim_customer`, `dim_product`, `dim_date`, `dim_branch`
- Power BI dashboard with 6 analytical views (revenue, membership, trainer, attendance, product, time-series)
- Docker Compose setup for local Airflow environment
- `.env.example` for secure credential management
- `SECURITY.md`, `CONTRIBUTING.md`, `CHANGELOG.md`
- `docs/DATA_DICTIONARY.md` with full schema documentation
- `docs/DEPLOYMENT.md` with step-by-step setup guide
- `docs/architecture/` folder for architecture diagrams

### Changed
- Standardized folder naming to `lowercase_with_underscores`
- Renamed `Data_Set/` → `raw_data/` to match Bronze-layer language in README
- Renamed `Cleaned_Data/` → `cleaned_data/` for consistency

---

## [0.1.0] — 2026-06 *(Initial Commits)*

### Added
- Initial project scaffold and repository structure
- README with architecture overview and Technology Stack
- Base Python ETL script, Airflow DAG, and SQL scripts
- Power BI `.pbix` file
- MIT License
