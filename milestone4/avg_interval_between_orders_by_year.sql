
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
