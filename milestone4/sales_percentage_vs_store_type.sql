
WITH cte1 AS (
	SELECT store_type, SUM(product_quantity * product_price) AS total_sales
	FROM orders_table
	JOIN dim_store_details
	ON orders_table.store_code = dim_store_details.store_code
	JOIN dim_products ON
	orders_table.product_code = dim_products.product_code
	GROUP BY store_type
)
SELECT 	store_type, 
		total_sales,
		ROUND(
    		total_sales * 100.0 / SUM(total_sales)
			OVER (), 2
  		) AS "sales_made(%)"
FROM cte1
ORDER BY "sales_made(%)" DESC;
