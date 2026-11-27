# Brazilian Market Insights — E-Commerce Business Intelligence

## Project Overview

Brazilian Market Insights is a BI project analysing the Brazilian E-Commerce Public Dataset by Olist.

The project aims to transform raw e-commerce transaction data into business insights using PostgreSQL, Power BI and DAX.

The analysis will focus on sales performance, customer behaviour, product performance and delivery operations.

## Objectives

- Design and implement a relational database using PostgreSQL.
- Develop an analytical data model using a star schema.
- Perform advanced SQL analysis using CTEs, window functions, aggregations and joins.
- Develop business performance metrics using DAX.
- Build an interactive Power BI dashboard for business stakeholders.
- Translate analytical findings into actionable business insights.

## Technology Stack

| Technology | Purpose |
|---|---|
| PostgreSQL | Database management and data modelling |
| SQL | Data transformation and business analysis |
| Power BI | Interactive dashboards and visualisation |
| DAX | Business metrics and analytical calculations |
| Git/GitHub | Version control and documentation |

## Dataset

**Source:** Brazilian E-Commerce Public Dataset by Olist.

The dataset contains approximately 100,000 orders from a Brazilian e-commerce marketplace, covering customer information, orders, products, sellers, payments, reviews and delivery information.

Dataset: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce

The dataset is distributed under the CC BY-NC-SA 4.0 licence. Attribution and licence terms will be respected.

## Analysis Conducted

### 1. Sales Performance
- Total sales and order volume
- Average order value
- Monthly sales trends and month-over-month analysis
- Product category performance
- Revenue contribution and rankings

### 2. Customer Analytics
- Customer purchasing patterns
- Repeat customer rate and purchasing behaviour
- Customer retention and cohort analysis
- Repeat customer purchasing frequency

### 3. Product Analytics
- Product and category performance
- Product portfolio analysis by sales and units sold
- Revenue concentration across product categories

### 4. Operations & Delivery
- On-time delivery performance
- Average delivery time
- Delayed orders
- Geographic delivery performance

## Repository Structure

```text
brazilian-market-insights/
│
├── data/
│   └── raw/
├── sql/
│   ├── analysis/
│   └── raw_table_creation.sql
├── powerbi/
│   ├── consumer_insights_dashboard.pbix
├── screenshots/
├── docs/
│   ├── data_exploration.py
│   ├── key_analysis.py
│   └── star_schema_design.md
├── .gitignore
└── README.md
```

## Project Status

**Completed:**

1. Dataset acquisition and exploration across all 9 source datasets.
2. PostgreSQL database setup and raw data ingestion.
3. Data validation and integrity checks.
4. Star schema design, implementation and loading.
5. Advanced SQL analysis covering sales, customer behaviour, product performance and delivery operations.
6. Power BI data modelling, relationships, date table configuration and DAX measure development.
7. Development of the Executive Overview dashboard.
8. Development of Customer & Product Analytics dashboard.
9. Development of Repeat Customer Analytics dashboard.
10. Interactive report filters, KPI cards and business analysis visualisations.

The project has been completed and documented as a portfolio project.  

### Data Exploration Findings

- Explored all 9 CSV datasets, containing approximately 1.55 million records.
- Identified primary keys and composite keys across the datasets.
- Validated 6 foreign key relationships, with zero unmatched records.
- Identified repeated `customer_unique_id` and `review_id` values, distinguishing them from duplicate records.
- Investigated geolocation data and identified multiple coordinate records for many ZIP code prefixes.
- Documented missing values and data quality considerations.

### Data Ingestion Summary
- Created a PostgreSQL database with a dedicated schema and imported all 9 raw datasets.  
- Validated imported record counts against original datasets. 
- Created 5 dimension tables and 4 fact tables.
- Implemented surrogate keys and primary/foreign key relationships.
- Populated dimensions and fact tables from the raw Olist datasets.
- Created a reusable date dimension.
- Calculated delivery duration and delivery delay metrics.
- Validated fact table record counts against raw source tables. 

**Total records: 1,550,922**

## Metric Definitions & Assumptions

- **Total Sales:** Sum of product item prices, excluding freight charges.
- **Average Order Value (AOV):** Total sales divided by the number of distinct orders.
- **Repeat Customer:** A unique customer with at least two delivered orders.
- **Customer Retention:** Repeat purchasing activity analysed across monthly customer cohorts.
- **Profitability:** Not calculated, as product cost and profit data are unavailable in the dataset.

## Final Deliverable

Completed an end-to-end business intelligence project using PostgreSQL, advanced SQL, dimensional modelling, DAX and Power BI.

The project transforms raw e-commerce data into an analytical data model and interactive dashboards covering sales performance, customer behaviour, product performance and delivery operations.