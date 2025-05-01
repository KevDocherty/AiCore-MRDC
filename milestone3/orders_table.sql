-- display the orders_table...
SELECT * FROM orders_table;

-- show column datatypes of orders_table...
SELECT 
    column_name, 
    data_type
FROM 
    information_schema.columns
WHERE 
    table_name = 'orders_table';

-- show the max length of column values...
SELECT MAX(LENGTH(product_code)) AS prodcode_length
FROM orders_table;

SELECT MAX(LENGTH(card_number)) AS cardnumber_length
FROM orders_table;

SELECT MAX(LENGTH(store_code)) AS storecode_length
FROM orders_table;

-- cast column data types...
ALTER TABLE orders_table
ALTER COLUMN date_uuid TYPE UUID USING date_uuid::UUID;

ALTER TABLE orders_table
ALTER COLUMN user_uuid TYPE UUID USING user_uuid::UUID;

ALTER TABLE orders_table
ALTER COLUMN card_number TYPE TEXT USING card_number::TEXT;

ALTER TABLE orders_table
ALTER COLUMN card_number TYPE VARCHAR(19) USING card_number::VARCHAR(19);

ALTER TABLE orders_table
ALTER COLUMN store_code TYPE VARCHAR(12) USING store_code::VARCHAR(12);

ALTER TABLE orders_table
ALTER COLUMN product_code TYPE VARCHAR(11) USING product_code::VARCHAR(11);

ALTER TABLE orders_table
ALTER COLUMN product_quantity TYPE SMALLINT USING product_quantity::SMALLINT;

-- show column datatypes after above changes...
SELECT 
    column_name, 
    data_type
FROM 
    information_schema.columns
WHERE 
    table_name = 'orders_table';

