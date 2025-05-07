-- This query compares the number of sales and product quantities sold through the web portal and offline stores.
-- It joins the orders_table with dim_store_details to get the store type and groups the results by store category.
-- The final result is ordered by the number of sales in ascending order.
-- The query assumes that the orders_table contains the necessary columns for product quantity and store code.
-- The query also joins with the dim_store_details table to get the required information.
-- The query retrieves the number of sales and product quantities sold through the web portal and offline stores.
-- It uses the COUNT function to calculate the number of sales and the SUM function to calculate the total product quantity sold.
-- It groups the results by store category (Web or Offline) and orders them by the number of sales in ascending order.
-- The final result is ordered by the number of sales in ascending order.

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
