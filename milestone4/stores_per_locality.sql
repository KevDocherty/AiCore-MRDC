SELECT * FROM dim_store_details;

SELECT locality, COUNT(*) as total_no_stores
FROM dim_store_details
GROUP BY locality
ORDER BY total_no_stores DESC;