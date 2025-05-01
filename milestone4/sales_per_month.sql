SELECT * FROM orders_table;

SELECT SUM(product_price * product_quantity) AS total_sales, month
FROM orders_table
JOIN dim_products ON dim_products.product_code = orders_table.product_code
JOIN dim_date_times ON dim_date_times.date_uuid = orders_table.date_uuid
GROUP BY month
ORDER By total_sales DESC;

