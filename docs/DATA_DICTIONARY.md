# Data Dictionary — Gym Sales Star Schema

This document describes the Gold Layer Snowflake Star Schema for the `GYM_DB.GOLD` schema.

---

## Schema Overview

```
                        ┌─────────────────┐
                        │   fact_sales    │
                        │─────────────────│
                        │ sale_id (PK)    │
          ┌─────────────│ customer_id(FK) │─────────────┐
          │             │ product_id (FK) │             │
          ▼             │ branch_id  (FK) │             ▼
  ┌──────────────┐      │ date_id    (FK) │      ┌──────────────┐
  │ dim_customer │      │ quantity        │      │  dim_product │
  │──────────────│      │ unit_price      │      │──────────────│
  │ customer_id  │      │ total_amount    │      │ product_id   │
  │ name         │      │ payment_method  │      │ product_name │
  │ gender       │      └────────┬────────┘      │ category     │
  │ age          │               │               │ unit_price   │
  │ membership   │      ┌────────┘               └──────────────┘
  │ join_date    │      │
  └──────────────┘      ▼
                ┌──────────────┐      ┌──────────────┐
                │   dim_date   │      │  dim_branch  │
                │──────────────│      │──────────────│
                │ date_id      │      │ branch_id    │
                │ full_date    │      │ branch_name  │
                │ day          │      │ city         │
                │ month        │      │ region       │
                │ quarter      │      └──────────────┘
                │ year         │
                │ weekday      │
                └──────────────┘
```

---

## Tables

### `fact_sales` — Grain: one row per individual sale transaction

| Column | Type | Description | Nullable |
|--------|------|-------------|----------|
| `sale_id` | VARCHAR PK | Unique sale identifier | No |
| `customer_id` | VARCHAR FK | References `dim_customer` | No |
| `product_id` | VARCHAR FK | References `dim_product` | No |
| `branch_id` | VARCHAR FK | References `dim_branch` | No |
| `date_id` | VARCHAR FK | References `dim_date` | No |
| `quantity` | NUMBER | Units sold in transaction | No |
| `unit_price` | FLOAT | Price per unit at time of sale | No |
| `total_amount` | FLOAT | `quantity × unit_price` | No |
| `payment_method` | VARCHAR | e.g., `Cash`, `Credit Card`, `E-wallet` | Yes |
| `rating` | FLOAT | Customer satisfaction (1–10 scale) | Yes |

---

### `dim_customer` — Grain: one row per unique gym member

| Column | Type | Description | Nullable |
|--------|------|-------------|----------|
| `customer_id` | VARCHAR PK | Unique member identifier | No |
| `customer_name` | VARCHAR | Full name | Yes |
| `gender` | VARCHAR | `Male` / `Female` | Yes |
| `age` | NUMBER | Age in years | Yes |
| `membership_type` | VARCHAR | e.g., `Monthly`, `Annual`, `Daily` | Yes |
| `join_date` | DATE | Date of membership registration | Yes |

---

### `dim_product` — Grain: one row per product/service offered

| Column | Type | Description | Nullable |
|--------|------|-------------|----------|
| `product_id` | VARCHAR PK | Unique product identifier | No |
| `product_name` | VARCHAR | Name of product or service | No |
| `category` | VARCHAR | e.g., `Supplements`, `Classes`, `Equipment` | Yes |
| `unit_price` | FLOAT | Standard listed price | Yes |

---

### `dim_date` — Grain: one row per calendar day

| Column | Type | Description | Nullable |
|--------|------|-------------|----------|
| `date_id` | VARCHAR PK | Date key in `YYYYMMDD` format | No |
| `full_date` | DATE | Calendar date | No |
| `day` | NUMBER | Day of month (1–31) | No |
| `month` | NUMBER | Month number (1–12) | No |
| `month_name` | VARCHAR | e.g., `January` | No |
| `quarter` | NUMBER | Quarter (1–4) | No |
| `year` | NUMBER | 4-digit year | No |
| `weekday` | VARCHAR | e.g., `Monday` | No |
| `is_weekend` | BOOLEAN | True if Saturday or Sunday | No |

---

### `dim_branch` — Grain: one row per gym branch location

| Column | Type | Description | Nullable |
|--------|------|-------------|----------|
| `branch_id` | VARCHAR PK | Unique branch identifier | No |
| `branch_name` | VARCHAR | Branch display name | No |
| `city` | VARCHAR | City of operation | Yes |
| `region` | VARCHAR | Region or country | Yes |

---

## Design Notes

- **Grain:** `fact_sales` is at the individual transaction grain — one row = one sale event.
- **SCD Type:** All dimension tables are currently **SCD Type 1** (overwrite on change) — no history tracking.
- **Date Dimension:** Pre-populated for the full date range of the dataset to support time-intelligence measures in Power BI.
- **Null handling:** Nullable dimension attributes indicate fields not always present in the raw source data; `fact_sales` foreign keys are non-nullable to maintain referential integrity.
