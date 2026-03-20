# Cal.com - BI Analytics Portfolio Project

A **dbt + Snowflake** analytics project modeled after Cal.com's open-source schema to demonstrate data engineering and BI skills.

## 🎯 Context & Purpose

This project was built as a **value proposition** for a BI Analyst role at Cal.com. By leveraging Cal.com's public GitHub repository (`schema.prisma`), I reverse-engineered the core data model and built an analytics layer focused on a real business gap I identified: **No-show revenue leakage**.

## 🔍 The Business Problem

Cal.com's current Insights dashboard shows basic booking metrics. However, there's a critical gap:

> **"How much revenue are users losing from no-shows — and which event types are most at risk?"**

This project answers that question with a full analytics pipeline.

## 🏗️ Tech Stack

- **Data Warehouse:** Snowflake
- **Transformation:** dbt Core
- **Visualization:** Power BI Desktop

## 📊 Data Model

Based on Cal.com's `schema.prisma`, the following tables were simulated:

| Source Table | Type | Key Fields |
|---|---|---|
| `RAW_CAL_BOOKINGS` | Fact | `status`, `no_show_guest`, `start_time` |
| `RAW_CAL_EVENT_TYPES` | Dimension | `title`, `price` |
| `RAW_CAL_USERS` | Dimension | `username`, `plan` |

## 🔄 dbt Models

```
models/
├── sources.yml              # Source definitions (Snowflake RAW schema)
├── staging/
│   └── stg_cal_bookings.sql # Cleaned & renamed booking data
└── marts/
    └── fct_booking_funnel.sql # Final analytical table with revenue metrics
```

### Key Metric: `revenue_lost`
```sql
CASE 
    WHEN no_show_guest = TRUE AND price > 0 THEN price
    ELSE 0
END as revenue_lost
```

## 🚀 How to Run

1. **Setup Snowflake:** Create a database `CAL_COM_PROJ` with schema `RAW` and load the synthetic data.
2. **Configure Profile:** Copy `profiles.yml.example` and fill in your Snowflake credentials.
3. **Run dbt:**
```bash
python run_dbt.py run
```

## 📈 Power BI Dashboard

The final dashboard connects live to Snowflake and includes:
- **No-Show Rate KPI** — % of bookings where guest didn't attend
- **Revenue Lost KPI** — Total $ lost from paid no-shows
- **Revenue Saved KPI** — Successfully completed paid sessions
- **No-Show by Event Type** — Bar chart showing which event types have highest drop-off
- **Booking Status Funnel** — Conversion from Pending → Accepted → Completed
