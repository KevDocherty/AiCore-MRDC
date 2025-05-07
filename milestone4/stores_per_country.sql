-- This SQL query retrieves the total number of stores in each country from the dim_store_details table.
-- It groups the results by country code and orders them by the total number of stores in descending order.
-- The query assumes that the dim_store_details table contains the necessary columns for store numbers and country codes.
-- The final result is ordered by the total number of stores in descending order.

SELECT country_code, COUNT(*) as total_no_stores
FROM dim_store_details
GROUP BY country_code
ORDER BY total_no_stores DESC;
