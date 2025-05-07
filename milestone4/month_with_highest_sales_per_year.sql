-- This query retrieves the month with the highest sales for each year from the orders table.
-- It calculates the total sales for each month and year, ranks them, and selects the top month for each year.
-- It uses the ROW_NUMBER() window function to assign a rank to each month based on total sales,
-- and then filters to get the month with the highest sales for each year.
-- The final result is ordered by total sales in descending order.
-- The query assumes that the orders_table contains the necessary columns for product quantity, product price, and date.
-- The query also joins with the dim_store_details, dim_products, and dim_date_times tables to get the required information.
--

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
