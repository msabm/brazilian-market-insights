-- Product category performance
/*

Identifying top performing product categories using:
CTEs, JOINS, RANK, ROW_NUMBER, PARTITION BY

*/

WITH category_sales AS (
	SELECT COALESCE (
			dp.product_category_name_english, 'Unknown'
		) AS product_category,
		COUNT(*) AS units_sold,
		COUNT(DISTINCT foi.order_id) AS total_orders,
		SUM(foi.price) AS total_sales,
		AVG(foi.price) AS average_item_price
	FROM analytics.fact_order_items foi
	JOIN analytics.dim_products dp
		ON foi.product_key = dp.product_key
	GROUP BY COALESCE (dp.product_category_name_english, 'Unknown')
),
ranked_categories AS (
	SELECT *,
		RANK() OVER (ORDER BY total_sales DESC) AS sales_rank,
		RANK() OVER (ORDER BY units_sold DESC) AS volume_rank
	FROM category_sales
)

SELECT sales_rank,
	volume_rank,
	product_category,
	units_sold,
	total_orders,
	ROUND(total_sales::NUMERIC, 2) AS total_sales,
	ROUND(average_item_price::NUMERIC, 2) AS average_item_price
FROM ranked_categories
ORDER BY sales_rank;


-- Top 10 product sales

WITH product_sales AS (
	SELECT dp.product_id,
		COALESCE(dp.product_category_name_english, 'Unknown') AS product_category,
		COUNT(*) AS units_sold,
		COUNT(DISTINCT foi.order_id) AS total_orders,
		SUM(foi.price) AS total_sales
	FROM analytics.fact_order_items foi
	JOIN analytics.dim_products dp
		ON foi.product_key = dp.product_key
	GROUP BY dp.product_id, COALESCE(dp.product_category_name_english, 'Unknown')
),
ranked_products AS (
	SELECT *,
		ROW_NUMBER() OVER(ORDER BY total_sales DESC) AS sales_rank
	FROM product_sales
)
SELECT sales_rank,
	product_id,
	product_category,
	units_sold,
	total_orders,
	ROUND(total_sales::NUMERIC, 2) AS total_sales
FROM ranked_products
WHERE sales_rank <= 10
ORDER BY sales_rank;


-- Top 3 products by sales within each category

WITH product_sales AS (
	SELECT dp.product_id,
		COALESCE(dp.product_category_name_english, 'Unknown') AS product_category,
		COUNT(*) AS units_sold,
		COUNT(DISTINCT foi.order_id) AS total_orders,
		SUM(foi.price) AS total_sales
	FROM analytics.fact_order_items foi
	JOIN analytics.dim_products dp
		ON foi.product_key = dp.product_key
	GROUP BY dp.product_id, COALESCE(dp.product_category_name_english, 'Unknown')
),
ranked_products AS (
	SELECT *,
		ROW_NUMBER() OVER (
				PARTITION BY product_category
			ORDER BY total_sales DESC
		) AS category_rank
	FROM product_sales
)

SELECT product_category,
	category_rank,
	product_id,
	units_sold,
	total_orders,
	ROUND(total_sales::NUMERIC, 2) AS total_sales
FROM ranked_products
WHERE category_rank <= 3
ORDER BY product_category, category_rank;
