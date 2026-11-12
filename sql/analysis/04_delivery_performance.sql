-- Delivery performance by state
/*

Comparing delivery speed and delays across different states using:
CTEs, AVG, CASE

*/

SELECT dc.customer_state,
	COUNT(*) AS total_orders,
	ROUND(AVG(fo.delivery_days), 2) AS avg_delivery_days,
	ROUND(AVG(fo.delivery_delay_days), 2) AS avg_delay_days,
	COUNT(*) FILTER (WHERE fo.delivery_delay_days > 0) AS delayed_orders,
	ROUND(COUNT(*) FILTER (WHERE fo.delivery_delay_days > 0) * 100 
		/ COUNT(*), 2) AS "delayed_order_%"
FROM analytics.fact_orders fo
JOIN analytics.dim_customers dc
	ON fo.customer_key = dc.customer_key
WHERE fo.delivery_days IS NOT NULL
GROUP BY dc.customer_state
ORDER BY avg_delivery_days DESC;


-- Overall delivery performance
SELECT COUNT(*) AS total_delivered_orders,
	COUNT(*) FILTER (WHERE delivery_delay_days <= 0) AS "on_time/early_orders",
	COUNT(*) FILTER (WHERE delivery_delay_days > 0) AS delayed_orders,
	ROUND(COUNT(*) FILTER (WHERE delivery_delay_days > 0) * 100 
		/ COUNT(*), 2) AS "delayed_order_%",
	ROUND(AVG(delivery_days), 2) AS avg_delivery_days,
	ROUND(AVG(delivery_delay_days), 2) AS avg_delivery_delay_days
FROM analytics.fact_orders
WHERE delivery_delay_days IS NOT NULL AND delivery_days IS NOT NULL;


-- Delivery time distribution
SELECT CASE WHEN delivery_days <= 7 THEN '0-7 days'
			WHEN delivery_days <= 14 THEN '8-14 days'
			WHEN delivery_days <= 21 THEN '15-21 days'
			ELSE '22+ days'
		END AS delivery_bucket,
		COUNT(*) as total_orders,
		ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (), 2) AS "%_of_orders"
FROM analytics.fact_orders
WHERE delivery_days IS NOT NULL
GROUP BY delivery_bucket
ORDER BY MIN(delivery_days);















