-- Monthly sales trend and Month-over-month growth
/*

Analysing monthyl sales performance and growth using: 
CTEs, LAG, generate_series, COALESCE

*/

WITH monthly_sales AS (
	SELECT d.year,
		d.month,
		DATE_TRUNC('month', d.full_date)::DATE AS sales_month,
		COUNT(DISTINCT fo.order_id) AS total_orders,
		SUM(foi.price) AS total_sales
	FROM analytics.fact_order_items foi
	JOIN analytics.fact_orders fo
		ON foi.order_id = fo.order_id
	JOIN analytics.dim_date d
		ON fo.purchase_date_key = d.date_key
	GROUP BY d.year, d.month, DATE_TRUNC('month', d.full_date)::DATE
),

calender_months AS (
	SELECT generate_series(
			(SELECT MIN(sales_month) FROM monthly_sales),
			(SELECT MAX(sales_month) FROM monthly_sales),
			INTERVAL '1 month'
	)::DATE AS sales_month
),

sales_with_previous_month AS (
	SELECT c.sales_month,
		COALESCE(m.total_orders, 0) AS total_orders,
		COALESCE(m.total_sales, 0) AS total_sales,
		LAG(COALESCE(m.total_sales, 0)) OVER 
			(ORDER BY c.sales_month) AS previous_month_sales
	FROM calender_months c
	LEFT JOIN monthly_sales m
		ON c.sales_month = m.sales_month
)

SELECT sales_month,
	total_orders,
	ROUND(total_sales::NUMERIC, 2) AS total_sales,
	ROUND(previous_month_sales::NUMERIC, 2) AS previous_month_sales,
	ROUND(
		((total_sales - previous_month_sales) / 
		NULLIF(previous_month_sales, 0)) * 100, 2
	) AS "mom_growth_%"
FROM sales_with_previous_month
ORDER BY sales_month;


