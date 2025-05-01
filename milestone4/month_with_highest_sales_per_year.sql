
WITH ranked_sales AS (
  SELECT 
    SUM(product_quantity * product_price) AS total_sales,
    year,
    month,
    ROW_NUMBER() OVER (PARTITION BY year ORDER BY SUM(product_quantity * product_price) DESC) AS rn
  FROM orders_table
	JOIN dim_store_details ON 
	orders_table.store_code = dim_store_details.store_code
	JOIN dim_products ON
		orders_table.product_code = dim_products.product_code
	JOIN dim_date_times ON
		orders_table.date_uuid = dim_date_times.date_uuid
	GROUP BY year, month
)
SELECT 
  	total_sales,
	year,
  	month
FROM ranked_sales
WHERE rn = 1
ORDER BY total_sales DESC;