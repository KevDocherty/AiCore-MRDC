-- perform data type harmonization of the 'dim_store_details' table columns...

-- display the dim_store_details table...
SELECT * FROM dim_store_details;

-- show column datatypes of dim_users table...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_store_details';

-- show the max length of column values...
SELECT MAX(LENGTH(store_code)) AS store_code_length
FROM dim_store_details;
-- store_code_length = 12

-- show the max length of column values...
SELECT MAX(LENGTH(country_code)) AS country_code_length
FROM dim_store_details;
-- country_code_length = 2

-- cast column data types...
ALTER TABLE dim_store_details
ALTER COLUMN longitude TYPE NUMERIC USING longitude::NUMERIC;

ALTER TABLE dim_store_details
ALTER COLUMN locality TYPE VARCHAR(255) USING locality::VARCHAR(255);

ALTER TABLE dim_store_details
ALTER COLUMN store_code TYPE VARCHAR(12) USING store_code::VARCHAR(12);

ALTER TABLE dim_store_details
ALTER COLUMN first_name TYPE VARCHAR(255) USING first_name::VARCHAR(255);

ALTER TABLE dim_store_details
ALTER COLUMN staff_numbers TYPE SMALLINT USING staff_numbers::SMALLINT;

ALTER TABLE dim_store_details
ALTER COLUMN opening_date TYPE DATE USING opening_date::DATE;

ALTER TABLE dim_store_details
ALTER COLUMN store_type TYPE VARCHAR(255),
ALTER COLUMN store_type DROP NOT NULL;

ALTER TABLE dim_store_details
ALTER COLUMN latitude TYPE NUMERIC USING latitude::NUMERIC;

ALTER TABLE dim_store_details
ALTER COLUMN country_code TYPE VARCHAR(2) USING country_code::VARCHAR(2);

ALTER TABLE dim_store_details
ALTER COLUMN continent TYPE VARCHAR(255) USING continent::VARCHAR(255);

-- show updated column datatypes of dim_store_details table...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_store_details';

-- display the entire table...
SELECT * FROM dim_store_details;

-- row 48 represents a web-address, and whose location attributes are set to '[null]'
-- display the affected row...
SELECT *
FROM dim_store_details
WHERE "store_type" = 'Web Portal';

-- note that the '[null]' values are greyed-out, and therefore likely already represent NULLs!

-- in the circumstance where the '[null]' values are strings...
UPDATE dim_store_details
SET
 	address = CASE WHEN address = '[null]' THEN NULL ELSE address END,
	locality = CASE WHEN locality = '[null]' THEN NULL ELSE address END,
	longitude = CASE WHEN longitude::TEXT = '[null]' THEN NULL ELSE longitude END,
	latitude  = CASE WHEN latitude::TEXT = '[null]' THEN NULL ELSE latitude END
WHERE "store_type" = 'Web Portal';

-- return a specific value from the row of interest...
SELECT address
FROM dim_store_details
WHERE "store_type" = 'Web Portal';

-- add store_code as PK...
ALTER TABLE dim_store_details
ADD PRIMARY KEY (store_code);

-- display entire table...
SELECT * FROM dim_store_details;
