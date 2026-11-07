# Star Schema Design

## 1. Overview

The analytical data model transforms the raw Olist e-commerce dataset into a dimensional model optimised for SQL analysis and Power BI reporting.

The model uses four fact tables and five dimension tables.

## 2. Fact Tables

| Fact Table | Grain | Key Measures |
|---|---|---|
| fact_order_items | One row per order item | Price, freight value, item quantity |
| fact_orders | One row per order | Order count, delivery duration, delivery delay |
| fact_payments | One row per payment transaction | Payment value, instalments |
| fact_reviews | One row per review per order | Review score |

## 3. Dimension Tables

| Dimension Table | Description |
|---|---|
| dim_customers | Customer identifiers and geographic information |
| dim_products | Product attributes and English category names |
| dim_sellers | Seller identifiers and geographic information |
| dim_payment_types | Distinct payment methods |
| dim_date | Calendar attributes for time-based analysis |

## 4. Relationships

- `fact_order_items` → `dim_customers`, `dim_products`, `dim_sellers`, `dim_date`
- `fact_orders` → `dim_customers`, `dim_date`
- `fact_payments` → `dim_payment_types`, `dim_date`
- `fact_reviews` → `dim_customers`, `dim_date`

Relationships will use surrogate dimension keys where appropriate, with one-to-many relationships from dimensions to facts.

## 5. Modelling Considerations

- Each fact table maintains its declared grain.
- Payment transactions and order items remain separate to prevent duplicated measures.
- `customer_unique_id` is retained to support repeat-customer analysis.
- Multiple date roles will be supported for purchase, approval, shipping, delivery and review dates.
- Geolocation will remain in the raw layer and will not be modelled as a separate analytical dimension initially.
- Missing source values will be preserved as NULL unless a specific business rule is defined.
