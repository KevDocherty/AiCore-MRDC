SELECT * FROM dim_store_details;

SELECT country_code, COUNT(*) as total_no_stores
FROM dim_store_details
GROUP BY country_code
ORDER BY total_no_stores DESC;