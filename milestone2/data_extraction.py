import pandas as pd
import tabula
import boto3
import requests
class DataExtractor():

    def read_rds_table(self, table_name, database_connector):
        '''
        reads a table from the database and returns it as a pandas dataframe
        '''
        creds = database_connector.read_db_creds()
        engine = database_connector.init_db_engine(creds)

        table_df = pd.read_sql_table(table_name, engine)
        return table_df

    def read_rds_table_by_query(self, query, engine):
        '''
        reads a table from the database and returns it as a pandas dataframe
        '''
        table_df = pd.read_sql_query(query, engine)
        return table_df

    def read_csv_table(self, table_name, csv_path):
        '''
        reads a csv file and returns it as a pandas dataframe
        '''
        table_df = pd.read_csv(f"{csv_path}/{table_name}.csv")
        return table_df

    def retrieve_pdf_data(self, pdf_path):
        """
        extracts all tables from all pages of a PDF and returns them as a single DataFrame.
        """
        # Extract all tables as a list of DataFrames
        tables = tabula.read_pdf(pdf_path, pages='all', multiple_tables=True)

        # Combine all tables into one DataFrame
        df = pd.concat(tables, ignore_index=True)

        return df

    def list_number_of_stores(self, csv_path):
        """
        Returns the number of unique stores in the table.
        """
        df = pd.read_csv(csv_path)

        # Assuming 'store_id' is the column that identifies unique stores
        unique_stores = df['store_code'].nunique()
        return unique_stores

    def retrieve_stores_data(self, csv_path):
        """
        Reads the stores data from a CSV file and returns it as a DataFrame.
        """
        df = pd.read_csv(csv_path)
        return df

    def extract_from_s3(self, s3_url):
        """
        Extracts data from an S3 bucket and returns it as a DataFrame.
        """
        s3 = boto3.client('s3')
        # Parse the S3 URL
        bucket_name = s3_url.split('/', 3)[2]
        print(f"Bucket name: {bucket_name}")
        # Extract the object key (file path)
        # The object key is everything after the bucket name
        object_key = s3_url.split('/', 3)[3]
        print(f"Object key: {object_key}")

        # Download the file from S3
        s3.download_file(bucket_name, object_key, 'temp_file.csv')

        # Read the CSV file into a DataFrame
        df = pd.read_csv('temp_file.csv')

        return df

    def extract_json_from_url(self, url):
        """
        Extracts data from a JSON file and returns it as a DataFrame.
        """

        # Get the JSON data from the URL
        response = requests.get(url)
        data = response.json()  # Converts the JSON content to a Python object

        # Optionally convert to a DataFrame
        df = pd.DataFrame(data)

        # return the result
        return df
