# AiCore-MRDC
AiCore Multi-National Retail Data Centralisation Project

## Project Description

A multinational company sells a diverse range of goods across the globe. However, its sales data are initially scattered across multiple sources, making them difficult to access and analyse effectively. To support a more data-driven approach, the organisation aims to consolidate this data into a single, centralised system.

### Objective

The first step is to retrieve and centralise the distributed sales data into a structured PostgreSQL database named sales_data. This process involves several key stages:
#### 1.	Database Setup
    •	Create a local PostgreSQL database called sales_data.
#### 2.	Data Retrieval
	•	Extract source data from AWS RDS and AWS S3 buckets.
	•	Load the data into Python using Pandas, resulting in several dataframes.
#### 3.	Data Cleaning
	•	Remove null values and duplicate records.
	•	Eliminate columns containing no useful information.
	•	Convert time-related fields to datetime format.
	•	Filter out erroneous records.
	•	Strip whitespace and remove non-numeric characters from numeric columns.
#### 4.	Data Integration
	•	Insert the cleaned dataframes as tables into the sales_data database.

### Database Structure

The resulting database will consist of six tables:
- A central **orders_table**
- Five supporting **dimension tables (dim_)**, which provide additional context:

| Table Name         | Description                          |
|--------------------|--------------------------------------|
| `dim_date_times`   | Dates and times of orders            |
| `dim_users`        | User/customer information            |
| `dim_card_details` | Payment card information             |
| `dim_products`     | Product details                      |
| `dim_store_details`| Store information                    |

### Establishing Relationships

To create a fully relational database structure, the following steps are carried out:
- Data Type Harmonisation
	- Ensure consistent column datatypes across all tables to enable seamless joins.
- Primary Key Assignment
	- Define primary keys in each of the dim_ tables.
- Foreign Key Mapping
	- Link the relevant columns in the orders_table to their corresponding entries in the dim_ tables using foreign keys.
 

The resulting relational sales_data database has a star structure, with the central orders_table connected radially to each of the dimension tables:

<img src="figures/sales_data_erd.png" alt="ERD Diagram" width="600"/>

The database is now able to be queried to reveal business metrics.

## File structure of the project

The project is comprised of 3 folders, as follows:

### Milestone2

Python code for the project, which is structured into files, classes, and methods, as follows:

- database_utils.py
    - class DatabaseConnector(): methods to connect-to, read-from, and upload-to AWS RDS and PostgreSQL databases
        - read_db_creds(): reads a credentials yaml file and returns a dictionary of the credentials
        - init_db_engine(): uses the credentials from read_db_creds and initialises and returns an sqlalchemy database engine
        - list_db_tables(): using the database engine, returns a list of tables in the database
        - upload_to_db(): uploads a pandas dataframe to a SQL database table
        
- data_extraction.py
    - class DataExtractor(): methods to extract data from a variety of sources, and return as pandas dataframes
        - read_rds_table(): reads a table from the database and returns it as a pandas dataframe
        - read_csv_table(): reads a csv file and returns it as a pandas dataframe
        - retrieve_pdf_data(): extracts all tables from all pages of a PDF and returns them as a pandas dataframe
        - list_number_of_stores(): returns the number of unique stores in a table
        - retrieve_stores_data(): reads the stores data from a CSV file and returns it as a pandas dataframe
        - extract_from_s3(): extracts data from an S3 bucket and returns it as a pandas dataframe
        - extract_json_from_url(): extracts data from a JSON file and returns it as a pandas dataframe

- data_cleaning.py
    - class DataCleaning(): methods to clean pandas dataframes
        - clean_user_data(): clean user data by removing null values, and converting date columns to datetime
        - clean_card_data(): clean card data by removing nulls and duplicates, filling missing values and converting date columns to datetime
        - called_clean_store_data(): clean store data by removing columns containing no useful information, 
        converting dates to datetime, removing non-numeric characters from staff-numbers, and removing nulls
        - convert_product_weights(): convert product weights to decimal numbers in kg
        - clean_products_data(): clean product data by removing nulls and columns containing no useful information
        - clean_orders_data(): clean orders data by removing columns containing no useful information
        - clean_date_events(): clean date events data by removing duplicates, converting time column to datetime,
        and converting date columns to numeric format

### Milestone3

- SQL scripts to harmonise and connect the 5 dimension tables to the central orders_table. 
- Entity Relationship DiagramERD files.

### Milestone4

Examples of SQL scripts to perform business analytics.

## Usage instructions

Please refer to the Jupyter Notebook **example_of_use.ipynb**, in the **milestone2** folder, for examples of how to use the code.

## License information

MIT Licence
