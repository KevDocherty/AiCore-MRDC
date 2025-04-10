import pandas as pd
import tabula
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

    def retrieve_pdf_data(self, pdf_path):

        """
        Extracts all tables from all pages of a PDF and returns them as a single DataFrame.
        """
        # Extract all tables as a list of DataFrames
        tables = tabula.read_pdf(pdf_path, pages='all', multiple_tables=True)

        # Combine all tables into one DataFrame
        df = pd.concat(tables, ignore_index=True)

        return df
