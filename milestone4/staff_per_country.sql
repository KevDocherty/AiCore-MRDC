-- This SQL query retrieves the total number of staff members for each country from the dim_store_details table.
-- It groups the results by country code and orders them by the total number of staff members in descending order.
-- The query assumes that the dim_store_details table contains the necessary columns for staff numbers and country codes.
-- The final result is ordered by the total number of staff members in descending order.

SELECT SUM(staff_numbers) AS total_staff_numbers, country_code
FROM dim_store_details
GROUP BY country_code
ORDER BY total_staff_numbers DESC;
