-- perform data type harmonization of the 'dim_products' table columns...

-- display the 'dim_products' table...
SELECT * FROM dim_products;

-- remove '£' from the 'product_price' column...
UPDATE dim_products
SET product_price = REPLACE(product_price, '£', '')
WHERE product_price LIKE '%£%';

-- display the 'dim_products' table...
SELECT * FROM dim_products;
-- '£' successfully removed from 'product_price'

-- add a new 'weight_class' column...
ALTER TABLE dim_products
ADD COLUMN weight_class VARCHAR(14);

-- assign values to weight_class depending upon the values in the 'weight' column...
UPDATE dim_products
SET weight_class = CASE
    WHEN weight < 2 THEN 'Light'
    WHEN weight >= 2 AND weight < 40 THEN 'Mid_Sized'
    WHEN weight >= 40 AND weight < 140 THEN 'Heavy'
    WHEN weight >= 140 THEN 'Truck_Required'
    ELSE NULL -- in case weight is NULL
END;

-- display the 'dim_products' table...
SELECT * FROM dim_products;
-- confirm 'weight_class' now correctly populated

-- cast the columns to be of the desired data type
-- first, display the current column datatypes...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_products';

-- show the max length of column values...
SELECT MAX(LENGTH("EAN")) AS EAN_length
FROM dim_products;
-- EAN_length = 17

-- show the max length of column values...
SELECT MAX(LENGTH(product_code)) AS prod_code_length
FROM dim_products;
-- prod_code_length = 11

-- show the max length of column values...
SELECT MAX(LENGTH(weight_class)) AS weight_class_length
FROM dim_products;
-- weight_class_length = 14

-- cast column data types...
ALTER TABLE dim_products
ALTER COLUMN product_price TYPE NUMERIC USING product_price::NUMERIC;

ALTER TABLE dim_products
ALTER COLUMN weight TYPE NUMERIC USING weight::NUMERIC;

ALTER TABLE dim_products
ALTER COLUMN store_code TYPE VARCHAR(12) USING store_code::VARCHAR(12);

ALTER TABLE dim_products
ALTER COLUMN "EAN" TYPE VARCHAR(17) USING "EAN"::VARCHAR(17);

ALTER TABLE dim_products
ALTER COLUMN product_code TYPE VARCHAR(11) USING product_code::VARCHAR(11);

ALTER TABLE dim_products
ALTER COLUMN weight_class TYPE VARCHAR(14) USING weight_class::VARCHAR(14);

ALTER TABLE dim_products
ALTER COLUMN date_added TYPE DATE USING date_added::DATE;

ALTER TABLE dim_products
ALTER COLUMN uuid TYPE UUID USING uuid::UUID;

-- rename 'removed' column to 'still_available'...
ALTER TABLE dim_products
RENAME COLUMN removed TO still_available;

-- change the contents of the 'still_available' column to be True or False...
UPDATE dim_products
SET still_available = CASE
    WHEN still_available = 'Still_avaliable' THEN 'true'
    WHEN still_available = 'Removed' THEN 'false'
    ELSE still_available
END;

ALTER TABLE dim_products
ALTER COLUMN still_available TYPE BOOL USING still_available::BOOL;


-- show updated column datatypes of dim_products table...
SELECT
    column_name,
    data_type
FROM
    information_schema.columns
WHERE
    table_name = 'dim_products';

-- display the entire table...
SELECT * FROM dim_products;

-- set product_code as PK...
ALTER TABLE dim_products
ADD PRIMARY KEY (product_code);
