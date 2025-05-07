-- This query calculates the total sales for each store type in Germany.
-- It joins the orders_table with dim_store_details and dim_products to get the necessary information.
-- It groups the results by store type and country code, filters for Germany, and orders the results by total sales in ascending order.
-- The query assumes that the orders_table contains the necessary columns for product quantity, product price, and store code.
-- The query also joins with the dim_store_details and dim_products tables to get the required information.
-- The query retrieves the total sales for each store type in Germany.
-- It uses the SUM function to calculate the total sales, groups the results by store type and country code,
-- and filters for Germany using the HAVING clause.
-- The final result is ordered by total sales in ascending order.

SELECT SUM(product_quantity * product_price) AS total_sales, store_type, country_code
FROM orders_table
JOIN dim_store_details
ON orders_table.store_code = dim_store_details.store_code
JOIN dim_products ON
orders_table.product_code = dim_products.product_code
GROUP BY store_type, country_code
HAVING country_code = 'DE'
ORDER BY total_sales ASC;
