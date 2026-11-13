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

## Planned Analysis

### 1. Sales Performance
- Total revenue and order volume
- Average order value
- Monthly revenue trends
- Product category performance
- Revenue contribution and rankings

### 2. Customer Analytics
- Customer purchasing patterns
- Repeat customer rate
- Customer retention
- Customer segmentation and cohort analysis

### 3. Operations & Delivery
- On-time delivery performance
- Average delivery time
- Delayed orders
- Seller performance
- Geographic delivery analysis

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

**1.** Initial setup and dataset acquisition.  
**2.** Dataset exploration and key analysis.  
**3.** PostgreSQL setup and raw data ingestion.  
**4.** Star schema design, implementation and data loading completed.  
**5.** Monthly sales trends, customer purchasing behaviour and product performance completed.  
**6.** Delivery performance analysis completed.  
**7.** Dashboard set up, configured data model relationships, marked date table, created core DAX measures and built initial visuals.


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

## Final Deliverable

A documented, portfolio-ready business intelligence project demonstrating database design, advanced SQL analysis, data modelling, DAX and interactive Power BI reporting.
