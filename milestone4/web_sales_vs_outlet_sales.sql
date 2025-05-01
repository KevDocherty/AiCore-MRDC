
SELECT 	COUNT(*) AS number_of_sales, 
		SUM(product_quantity) AS product_quantity_count,
		CASE 
    		WHEN store_type = 'Web Portal' THEN 'Web'
    		ELSE 'Offline'
  		END AS store_category
FROM orders_table
JOIN dim_store_details
ON orders_table.store_code = dim_store_details.store_code
GROUP BY store_category
ORDER BY number_of_sales;

