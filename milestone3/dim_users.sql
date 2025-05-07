-- this script performs data type harmonization of the 'dim_users' table columns...

-- display the dim_users table...
SELECT * FROM orders_table;

-- show column datatypes of dim_users table...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_users';

-- drop unwanted columns from dim_users...
ALTER TABLE dim_users
DROP COLUMN "Unnamed: 0";

ALTER TABLE dim_users
DROP COLUMN "index";

-- display the dim_users table...
SELECT * FROM dim_users;

-- show the max length of column values...
SELECT MAX(LENGTH(country_code)) AS country_code_length
FROM dim_users;

-- cast column data types...
ALTER TABLE dim_users
ALTER COLUMN first_name TYPE VARCHAR(255) USING first_name::VARCHAR(255);

ALTER TABLE dim_users
ALTER COLUMN last_name TYPE VARCHAR(255) USING last_name::VARCHAR(255);

ALTER TABLE dim_users
ALTER COLUMN date_of_birth TYPE DATE USING date_of_birth::DATE;

ALTER TABLE dim_users
ALTER COLUMN first_name TYPE VARCHAR(255) USING first_name::VARCHAR(255);

ALTER TABLE dim_users
ALTER COLUMN country_code TYPE VARCHAR(3) USING first_name::VARCHAR(3);

ALTER TABLE dim_users
ALTER COLUMN user_uuid TYPE UUID USING user_uuid::UUID;

ALTER TABLE dim_users
ALTER COLUMN join_date TYPE DATE USING join_date::DATE;

-- show column datatypes of dim_users table...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_users';
