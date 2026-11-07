-- Creating a new schema for analysis
CREATE SCHEMA IF NOT EXISTS analytics;


SELECT schema_name
FROM information_schema.schemata
WHERE schema_name = 'analytics';


-- Creating dimension tables
-- 1. Customers
CREATE TABLE analytics.dim_customers (
	customer_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	customer_id VARCHAR(50) UNIQUE NOT NULL,
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix INTEGER,
	customer_city VARCHAR(100),
	customer_state VARCHAR(5)
);

-- 2. Products
CREATE TABLE analytics.dim_products (
	product_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	product_id VARCHAR(50) UNIQUE NOT NULL,
	product_category_name VARCHAR(100),
	product_category_name_english VARCHAR(100),
	product_weight_g INTEGER,
    product_length_cm INTEGER,
    product_height_cm INTEGER,
    product_width_cm INTEGER
);


-- 3. Sellers
CREATE TABLE analytics.dim_sellers (
	seller_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	seller_id VARCHAR(50) UNIQUE NOT NULL,
	seller_zip_code_prefix INTEGER,
	seller_city VARCHAR(100),
	seller_state VARCHAR(5)
);


-- 4. Payment Types
CREATE TABLE analytics.dim_payment_types (
	payment_type_key INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	payment_type VARCHAR(30) UNIQUE NOT NULL
);


-- 5. Date
CREATE TABLE analytics.dim_date (
	date_key INTEGER PRIMARY KEY,
	full_date DATE UNIQUE NOT NULL,
	day INTEGER,
	month INTEGER,
	month_name VARCHAR(15),
	quarter INTEGER,
	year INTEGER,
	day_of_week INTEGER,
	day_name VARCHAR(15),
	is_weekend BOOLEAN
);


-- Creating fact tables
-- 1. Order Items
CREATE TABLE analytics.fact_order_items (
	order_id VARCHAR(50),
	order_item_id INTEGER,
	customer_key INTEGER REFERENCES analytics.dim_customers(customer_key),
	product_key INTEGER REFERENCES analytics.dim_products(product_key),
	seller_key INTEGER REFERENCES analytics.dim_sellers(seller_key),
	shipping_limit_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	price NUMERIC(12, 2),
	freight_value NUMERIC(12, 2),
	PRIMARY KEY (order_id, order_item_id)
);


-- 2. Orders
CREATE TABLE analytics.fact_orders (
	order_id VARCHAR(50) PRIMARY KEY,
	customer_key INTEGER REFERENCES analytics.dim_customers(customer_key),
	purchase_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	approved_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	carrier_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	delivered_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	estimated_delivery_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	order_status VARCHAR(30),
	delivery_date INTEGER,
	delivery_dalay_days INTEGER
);


-- 3. Payments
CREATE TABLE analytics.fact_payments (
	order_id VARCHAR(50),
	payment_sequential INTEGER,
	payment_type_key INTEGER REFERENCES analytics.dim_payment_types(payment_type_key),
	payment_installments INTEGER,
	payment_value NUMERIC(12, 2),
	PRIMARY KEY (order_id, payment_sequential)
);


-- 4. Reviews
CREATE TABLE analytics.fact_reviews (
	review_id VARCHAR(50),
	order_id VARCHAR(50),
	customer_key INTEGER REFERENCES analytics.dim_customers(customer_key),
	review_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	answer_date_key INTEGER REFERENCES analytics.dim_date(date_key),
	review_score INTEGER,
	PRIMARY KEY (review_id, order_id)
);



-- Populating the tables
-- 1. Customers
INSERT INTO analytics.dim_customers (
	customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
SELECT customer_id,
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
FROM raw.customers;


-- 2. Products
INSERT INTO analytics.dim_products (
	product_id,
	product_category_name,
	product_category_name_english,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
SELECT p.product_id,
	p.product_category_name,
	t.product_category_name_english,
	p.product_weight_g,
	p.product_length_cm,
	p.product_height_cm,
	p.product_width_cm
FROM raw. products p
LEFT JOIN raw.product_category_name_translation t
	ON p.product_category_name = t.product_category_name;


-- 3. Sellers
INSERT INTO analytics.dim_sellers (
	seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
)
SELECT seller_id,
	seller_zip_code_prefix,
	seller_city,
	seller_state
FROM raw.sellers;


-- 4. Payment types
INSERT INTO analytics.dim_payment_types (
	payment_type
)
SELECT DISTINCT payment_type
FROM raw.order_payments
WHERE payment_type IS NOT NULL;


-- Validating
SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count
FROM analytics.dim_customers
UNION ALL
SELECT 'dim_products', COUNT(*)
FROM analytics.dim_products
UNION ALL
SELECT 'dim_sellers', COUNT(*)
FROM analytics.dim_sellers
UNION ALL
SELECT 'dim_payment_types', COUNT(*)
FROM analytics.dim_payment_types;


-- 5. Date
INSERT INTO analytics.dim_date (
	date_key,
	full_date,
	day,
	month,
	month_name,
	quarter,
	year,
	day_of_week,
	day_name,
	is_weekend
)
SELECT TO_CHAR(d::DATE, 'YYYYMMDD')::INTEGER,
	d::DATE,
	EXTRACT(DAY FROM d)::INTEGER,
	EXTRACT(MONTH FROM d)::INTEGER,
	TO_CHAR(d, 'FMMonth'),
	EXTRACT(QUARTER FROM d)::INTEGER,
	EXTRACT(YEAR FROM d)::INTEGER,
	EXTRACT(ISODOW FROM d)::INTEGER,
	TO_CHAR(d, 'FMDay'),
	EXTRACT(ISODOW FROM d) IN (6, 7)
FROM GENERATE_SERIES (
	DATE '2016-01-01',
	DATE '2018-12-31',
	INTERVAL '1 day'
) AS d;


SELECT COUNT(*) AS total_dates,
	MIN(full_date) AS first_date,
	MAX(full_date) AS last_date
FROM analytics.dim_date;








