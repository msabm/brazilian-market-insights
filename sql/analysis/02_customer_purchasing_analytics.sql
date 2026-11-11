-- Customer Purchase Frequency
/*

Identifying one time and repeat customers using:
CTEs, COUNT DISTINCT, CASE, FILTER

*/

WITH customer_orders AS (
	SELECT dc.customer_unique_id,
		COUNT(DISTINCT fo.order_id) AS total_orders
	FROM analytics.fact_orders fo
	JOIN analytics.dim_customers dc
		ON fo.customer_key = dc.customer_key
	GROUP BY dc.customer_unique_id
)

SELECT customer_unique_id,
	total_orders,
	CASE WHEN total_orders = 1 THEN 'One-time customer'
		ELSE 'Repeat customer'
	END AS customer_type
FROM customer_orders
ORDER BY total_orders DESC;


-- Customer purchase frequency summary

WITH customer_orders AS (
	SELECT dc.customer_unique_id,
		COUNT(DISTINCT fo.order_id) AS total_orders
	FROM analytics.fact_orders fo
	JOIN analytics.dim_customers dc
		ON fo.customer_key = dc.customer_key
	GROUP BY dc.customer_unique_id
)

SELECT COUNT(*) AS total_customers,
	COUNT(*) FILTER (
		WHERE total_orders = 1
	) AS one_time_customers,
	COUNT(*) FILTER (
		WHERE total_orders > 1
	) AS repeat_customers,
	ROUND(
		COUNT(*) FILTER (WHERE total_orders > 1)::NUMERIC
		/ COUNT(*) * 100, 2
	) AS "repeat_customer_%",
	ROUND(AVG(total_orders), 2) AS average_orders_per_customer,
	MAX(total_orders) AS highest_orders_by_customer
FROM customer_orders;


-- Customer purchase frequency distribution

WITH customer_orders AS (
    SELECT
        dc.customer_unique_id,
        COUNT(DISTINCT fo.order_id) AS total_orders
    FROM analytics.fact_orders fo
    JOIN analytics.dim_customers dc
        ON fo.customer_key = dc.customer_key
    GROUP BY dc.customer_unique_id
)

SELECT CASE
		WHEN total_orders = 1 THEN 'order'
		WHEN total_orders = 2 THEN '2 orders'
		WHEN total_orders = 3 THEN '3 orders'
		ELSE '4+ orders'
	END AS purchase_frequency,
	COUNT(*) AS customer_count
FROM customer_orders
GROUP BY 1
ORDER BY MIN(total_orders);


