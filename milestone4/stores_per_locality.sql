-- This SQL query retrieves the number of stores in each locality from the dim_store_details table.
-- It groups the results by locality and orders them by the total number of stores in descending order.
-- The query assumes that the dim_store_details table contains the necessary columns for store numbers and locality.
-- The final result is ordered by the total number of stores in descending order.

SELECT locality, COUNT(*) as total_no_stores
FROM dim_store_details
GROUP BY locality
ORDER BY total_no_stores DESC;
