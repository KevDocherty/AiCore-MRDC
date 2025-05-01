
SELECT SUM(product_quantity * product_price) AS total_sales, store_type, country_code
FROM orders_table
JOIN dim_store_details
ON orders_table.store_code = dim_store_details.store_code
JOIN dim_products ON
orders_table.product_code = dim_products.product_code
GROUP BY store_type, country_code
HAVING country_code = 'DE'
ORDER BY total_sales ASC;