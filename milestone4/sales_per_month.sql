-- This SQL query calculates the total sales for each month by joining the orders_table with the dim_products and dim_date_times tables.
-- It groups the results by month and orders them by total sales in descending order.
-- The query assumes that the orders_table contains the necessary columns for product quantity, product price, and date.
-- The query also joins with the dim_products and dim_date_times tables to get the required information.
-- The final result is ordered by total sales in descending order.

SELECT SUM(product_price * product_quantity) AS total_sales, month
FROM orders_table
JOIN dim_products ON dim_products.product_code = orders_table.product_code
JOIN dim_date_times ON dim_date_times.date_uuid = orders_table.date_uuid
GROUP BY month
ORDER By total_sales DESC;
