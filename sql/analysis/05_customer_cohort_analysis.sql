-- Customer cohort retention analysis
/*

Cohort = month of first delivered order
Retention = percentage of cohort customers
Analysis of repeat customers who placed orders in subsequent months

*/

CREATE VIEW analytics.vw_customer_cohort_retention AS (
	WITH customer_months AS (
		SELECT DISTINCT dc.customer_unique_id,
			DATE_TRUNC('month', dd.full_date)::DATE AS order_month
		FROM analytics.fact_orders fo
		JOIN analytics.dim_customers dc
			ON fo.customer_key = dc.customer_key
		JOIN analytics.dim_date dd
			ON fo.purchase_date_key = dd.date_key
		WHERE fo.order_status = 'delivered'
			AND dc.customer_unique_id IS NOT NULL
			AND fo.purchase_date_key IS NOT NULL
	),
	
	customer_cohorts AS (
		SELECT customer_unique_id,
			MIN(order_month) AS cohort_month
		FROM customer_months
		GROUP BY customer_unique_id
	),
	
	cohort_sizes AS (
		SELECT cohort_month,
			COUNT(*) AS cohort_size
		FROM customer_cohorts
		GROUP BY cohort_month
	),
	
	cohort_activity AS (
		SELECT cc.cohort_month,
			cm.order_month,
			(
				(EXTRACT(YEAR FROM cm.order_month) - 
				EXTRACT(YEAR FROM cc.cohort_month)) * 12
				+
				(EXTRACT(MONTH FROM cm.order_month) - 
				EXTRACT(MONTH FROM cc.cohort_month))
			)::INT AS months_since_first_purchase,
			COUNT(DISTINCT cm.customer_unique_id) AS active_customers
		FROM customer_months cm
		JOIN customer_cohorts cc
			ON cm.customer_unique_id = cc.customer_unique_id
		GROUP BY cc.cohort_month, cm.order_month
	),
	
	latest_month AS (
		SELECT MAX(order_month) AS max_month
		FROM customer_months
	),
	
	cohort_periods AS (
		SELECT cs.cohort_month,
			cs.cohort_size,
			periods.month_number AS months_since_first_purchase
		FROM cohort_sizes cs
		CROSS JOIN latest_month lm
		CROSS JOIN LATERAL GENERATE_SERIES(0,
			((EXTRACT(YEAR FROM lm.max_month) -
			EXTRACT(YEAR FROM cs.cohort_month)) * 12
			+
			(EXTRACT(MONTH FROM lm.max_month) -
			EXTRACT(MONTH FROM cs.cohort_month)))::INT
		) AS periods(month_number)
	)
	
	SELECT
		cp.cohort_month,
		cp.months_since_first_purchase,
		cp.cohort_size,
		COALESCE(ca.active_customers, 0) AS active_customers,
		ROUND(
			(100 * COALESCE(ca.active_customers, 0) 
			/ NULLIF(cp.cohort_size, 0)::NUMERIC), 2) AS retention_rate
	FROM cohort_periods cp
	LEFT JOIN cohort_activity ca
		ON cp.cohort_month = ca.cohort_month
		AND cp.months_since_first_purchase = ca.months_since_first_purchase
	ORDER BY cp.cohort_month, cp.months_since_first_purchase
);


SELECT * 
FROM analytics.vw_customer_cohort_retention
ORDER BY cohort_month, months_since_first_purchase;

