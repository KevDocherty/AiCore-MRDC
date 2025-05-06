-- perform data type harmonization of the 'dim_date_times' table columns...

-- display the 'dim_date_times' table...
SELECT * FROM dim_date_times;

-- display the current column datatypes...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_date_times';

-- cast the columns to be of the desired data type

-- show the max length of column values...
SELECT MAX(LENGTH(time_period)) AS time_period_length
FROM dim_date_times;
-- time_period_length = 10

-- cast column data types...
ALTER TABLE dim_date_times
ALTER COLUMN month TYPE VARCHAR(2) USING month::VARCHAR(2);

ALTER TABLE dim_date_times
ALTER COLUMN year TYPE VARCHAR(4) USING year::VARCHAR(4);

ALTER TABLE dim_date_times
ALTER COLUMN day TYPE VARCHAR(2) USING day::VARCHAR(2);

ALTER TABLE dim_date_times
ALTER COLUMN time_period TYPE VARCHAR(10) USING time_period::VARCHAR(10);

ALTER TABLE dim_date_times
ALTER COLUMN date_uuid TYPE UUID USING date_uuid::UUID;

-- show updated column datatypes of dim_date_times table...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_date_times';

-- display the entire table...
SELECT * FROM dim_date_times;

-- set date_uuid as PK...
ALTER TABLE dim_date_times
ADD PRIMARY KEY (date_uuid);
