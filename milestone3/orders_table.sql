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

-- display entire table...
SELECT * FROM orders_table;

SELECT COUNT(*), COUNT(DISTINCT product_code)
FROM orders_table;

-- connect orders_table to dim_products using the common product_code column...
ALTER TABLE orders_table
ADD CONSTRAINT fk_orders_product_code
FOREIGN KEY (product_code)
REFERENCES dim_products(product_code);

-- connect orders_table to dim_date_times using the common date_uuid column...
ALTER TABLE orders_table
ADD CONSTRAINT fk_orders_date_uuid
FOREIGN KEY (date_uuid)
REFERENCES dim_date_times(date_uuid);

-- connect orders_table to dim_users using the common user_uuid column...
ALTER TABLE orders_table
ADD CONSTRAINT fk_orders_user_uuid
FOREIGN KEY (user_uuid)
REFERENCES dim_users(user_uuid);

-- connect orders_table to dim_card_details using the common card_number column...
ALTER TABLE orders_table
ADD CONSTRAINT fk_orders_card_number
FOREIGN KEY (card_number)
REFERENCES dim_card_details(card_number);

-- connect orders_table to dim_store_details using the common store_code column...
ALTER TABLE orders_table
ADD CONSTRAINT fk_orders_store_code
FOREIGN KEY (store_code)
REFERENCES dim_store_details(store_code);