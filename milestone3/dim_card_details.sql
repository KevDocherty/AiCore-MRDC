-- this script performs data type harmonisation of the 'dim_card_details' table columns...

-- display the 'dim_card_details' table...
SELECT * FROM dim_card_details;

-- display the current column datatypes...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_card_details';

-- show the max length of column values...
SELECT MAX(LENGTH(card_number)) AS card_number_length
FROM dim_card_details;
-- card_number_length = 19

-- show the max length of column values...
SELECT MAX(LENGTH(expiry_date)) AS expiry_length
FROM dim_card_details;
-- expiry_length = 5

-- cast column data types...
ALTER TABLE dim_card_details
ALTER COLUMN card_number TYPE VARCHAR(19) USING card_number::VARCHAR(19);

ALTER TABLE dim_card_details
ALTER COLUMN expiry_date TYPE VARCHAR(5) USING expiry_date::VARCHAR(5);

ALTER TABLE dim_card_details
ALTER COLUMN date_payment_confirmed TYPE DATE USING date_payment_confirmed::DATE;

-- show updated column datatypes of dim_date_times table...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_card_details';

-- display the entire table...
SELECT * FROM dim_card_details;
