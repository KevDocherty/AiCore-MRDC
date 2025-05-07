-- This query calculates the average time interval between orders for each year.
-- It uses the `orders_table` and `dim_date_times` tables to extract the necessary information.
-- The result is a JSON object containing the average time taken in hours, minutes, seconds, and milliseconds.
-- The query is structured in several steps:
-- 1. Extract the year, month, and day from the timestamp in the `orders_table`.
-- 2. Create a full timestamp using the extracted year, month, day, and the time from the original timestamp.
-- 3. Use the `LEAD` function to get the next timestamp for each year.
-- 4. Calculate the time difference between consecutive timestamps.
-- 5. Calculate the average time difference for each year.
-- 6. Format the average time difference into a JSON object with hours, minutes, seconds, and milliseconds.
-- 7. Return the year and the formatted average time difference, ordered by the average time difference in descending order.
-- The query assumes that the `orders_table` contains a `date_uuid` column that links to the `dim_date_times` table.


WITH timestamp_year_month_day AS (
	SELECT timestamp, year, month, day
	FROM orders_table
	JOIN dim_date_times ON
	dim_date_times.date_uuid = orders_table.date_uuid
),
full_timestamps AS (
  SELECT
    year,
    MAKE_TIMESTAMP(
      year::int,
      month::int,
      day::int,
      EXTRACT(HOUR FROM timestamp)::int,
      EXTRACT(MINUTE FROM timestamp)::int,
      EXTRACT(SECOND FROM timestamp)::int
    ) AS full_ts
  FROM timestamp_year_month_day
),
ordered AS (
  SELECT
    year,
    full_ts,
    LEAD(full_ts) OVER (PARTITION BY year ORDER BY full_ts) AS next_ts
  FROM full_timestamps
),
time_diffs AS (
  SELECT
    year,
    EXTRACT(EPOCH FROM (next_ts - full_ts)) AS diff_seconds
  FROM ordered
  WHERE next_ts IS NOT NULL
),
average_diffs AS (
  SELECT
    year,
    AVG(diff_seconds) AS avg_seconds
  FROM time_diffs
  GROUP BY year
)
SELECT
  year,
  json_build_object(
    'hours', FLOOR(avg_seconds / 3600),
    'minutes', FLOOR((avg_seconds % 3600) / 60),
    'seconds', FLOOR(avg_seconds % 60),
    'milliseconds', FLOOR((avg_seconds - FLOOR(avg_seconds)) * 1000)
  ) AS actual_time_taken
FROM average_diffs
ORDER BY avg_seconds DESC;
