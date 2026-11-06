--Creating Tables
-- 1. Customers
CREATE TABLE raw.customers (
	customer_id VARCHAR(50) PRIMARY KEY,
	customer_unique_id VARCHAR(50),
	customer_zip_code_prefix INTEGER,
	customer_city VARCHAR(100),
	customer_state VARCHAR(5)
);


-- 2. Geolocation
CREATE TABLE raw.geolocation (
	geolocation_zip_code_prefix INTEGER,
	geolocation_lat NUMERIC(12, 8),
	geolocation_lng NUMERIC(12, 8),
	geolocation_city VARCHAR(100),
	geolocation_state VARCHAR(5)
);


-- 3. Orders
CREATE TABLE raw.orders (
	order_id VARCHAR(50) PRIMARY KEY,
	customer_id VARCHAR(50),
	order_status VARCHAR(30),
	order_purchase_timestamp TIMESTAMP,
	order_approved_at TIMESTAMP,
	order_delivered_carrier_date TIMESTAMP,
	order_delivered_customer_date TIMESTAMP,
	order_estimated_delivery_date TIMESTAMP
);


-- 4. Order Items
CREATE TABLE raw.order_items (
	order_id VARCHAR(50),
	order_item_id INTEGER,
	product_id VARCHAR(50),
	seller_id VARCHAR(50),
	shipping_limit_date TIMESTAMP,
	price NUMERIC(12, 2),
	freight_value NUMERIC(12, 2),
	PRIMARY KEY (order_id, order_item_id)
);


-- 5. Payments
CREATE TABLE raw.order_payments (
	order_id VARCHAR(50),
	payment_sequential INTEGER,
	payment_type VARCHAR(30),
	payment_installments INTEGER,
	payment_value NUMERIC(12, 2),
	PRIMARY KEY (order_id, payment_sequential)
);


-- 6. Reviews
CREATE TABLE raw.order_reviews (
	review_id VARCHAR(50),
	order_id VARCHAR(50),
	review_score INTEGER,
	review_comment_title TEXT,
	review_comment_message TEXT,
	review_creation_date TIMESTAMP,
	review_answer_timestamp TIMESTAMP,
	PRIMARY KEY (review_id, order_id)
);


-- 7. Products
CREATE TABLE raw.products (
	product_id VARCHAR(50) PRIMARY KEY,
	product_category_name VARCHAR(100),
	product_name_lenght INTEGER,
	product_description_lenght INTEGER,
	product_photos_qty INTEGER,
	product_weight_g INTEGER,
	product_length_cm INTEGER,
	product_height_cm INTEGER,
	product_width_cm INTEGER
);


-- 8. Sellers
CREATE TABLE raw.sellers (
	seller_id VARCHAR(50) PRIMARY KEY,
	seller_zip_code_prefix INTEGER,
	seller_city VARCHAR(100),
	seller_state VARCHAR(5)
);


-- 9. Product Category Translation
CREATE TABLE raw.product_category_name_translation (
	product_category_name VARCHAR(100) PRIMARY KEY,
	product_category_name_english VARCHAR(100)
);


-- verifying table creation
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'raw'
ORDER BY table_name;


--verifying data import
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM raw.customers
UNION ALL
SELECT 'geolocation', COUNT(*) FROM raw.geolocation
UNION ALL
SELECT 'orders', COUNT(*) FROM raw.orders
UNION ALL
SELECT 'order_items', COUNT(*) FROM raw.order_items
UNION ALL
SELECT 'order_payments', COUNT(*) FROM raw.order_payments
UNION ALL
SELECT 'order_reviews', COUNT(*) FROM raw.order_reviews
UNION ALL
SELECT 'products', COUNT(*) FROM raw.products
UNION ALL
SELECT 'sellers', COUNT(*) FROM raw.sellers
UNION ALL
SELECT 'product_category_name_translation', COUNT(*) from raw.product_category_name_translation
ORDER BY table_name;









