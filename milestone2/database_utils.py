import yaml
#import psycopg2
import pandas as pd
import numpy as np
from sqlalchemy import create_engine
from sqlalchemy import inspect

class DatabaseConnector():

    def read_db_creds(self):
        '''
        reads the credentials yaml file and returns a dictionary of the credentials
        '''
        with open('db_creds.yaml', 'r') as f:
            credentials = yaml.safe_load(f)
        return credentials

    def init_db_engine(self, credentials):
        '''
        read the credentials from read_db_creds and initialise and return an sqlalchemy database engine
        '''
        #DATABASE_TYPE = credentials["RDS_DATABASE"]
        #DBAPI = 'psycopg2'
        HOST = credentials["RDS_HOST"]
        USER = credentials["RDS_USER"]
        PASSWORD = credentials["RDS_PASSWORD"]
        DATABASE = credentials["RDS_DATABASE"]
        PORT = credentials["RDS_PORT"]

        DATABASE_URL = f"postgresql://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}"
        engine = create_engine(DATABASE_URL)

        return engine

    def list_db_tables(self, engine):
        '''
        returns a list of tables in the database
        '''
        inspector = inspect(engine)
        tables = inspector.get_table_names()
        return tables

    def upload_to_db(self, df, table_name):
        '''
        uploads a pandas dataframe to the database
        '''

        # Read the credentials from the YAML file
        # and create a database engine
        with open('local_db_creds.yaml', 'r') as f:
            credentials = yaml.safe_load(f)

        DATABASE_TYPE = credentials["DATABASE_TYPE"]
        DBAPI = credentials["DBAPI"]
        HOST = credentials["HOST"]
        USER = credentials["USER"]
        PASSWORD = credentials["PASSWORD"]
        DATABASE = credentials["DATABASE"]
        PORT = credentials["PORT"]

        engine = create_engine(f"{DATABASE_TYPE}+{DBAPI}://{USER}:{PASSWORD}@{HOST}:{PORT}/{DATABASE}")

        # Upload the DataFrame to the database
        df.to_sql(table_name, engine, if_exists='replace', index=False)
        print(f"DataFrame uploaded to {table_name} table in the database.")
        # Close the database connection
        engine.dispose()
