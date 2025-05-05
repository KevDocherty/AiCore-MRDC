import pandas as pd
import numpy as np
import re

def extract_weight_kg(value):
    '''
    Module function to take weight values in numeric string format,
    strip off the units characters ('g', 'kg', 'ml', and 'oz'),
    and return as a float representing decimal kg.
    This function is available to the methods within the DataCleaning() class.
    '''
    try:
        value = str(value).lower().strip()

        allowed_units = ['g', 'kg', 'ml', 'oz']

        # Remove valid units temporarily to check for bad characters
        cleaned = re.sub(r'(kg|ml|oz|g)', '', value)

        # If cleaned string contains disallowed characters, return NaN
        if not re.fullmatch(r'[\d\.\sx ]+', cleaned):
            return np.nan

        # If no valid unit present, return NaN
        if not any(unit in value for unit in allowed_units):
            return np.nan

        # Case 1: compound format like "12 x 100g", "3x2oz"
        if 'x' in value:
            numbers = re.findall(r'(\d+\.?\d*)', value)
            if len(numbers) >= 2:
                quantity = float(numbers[0])
                unit_amount = float(numbers[1])
                if 'g' in value or 'ml' in value:
                    return (quantity * unit_amount) / 1000
                elif 'kg' in value:
                    return quantity * unit_amount
                elif 'oz' in value:
                    return quantity * unit_amount * 0.0283495

        # Case 2: single values like "500g", "1.5 kg", "12oz"
        if 'kg' in value:
            match = re.search(r'(\d+\.?\d*)', value)
            if match:
                return float(match.group(1))
        elif 'g' in value or 'ml' in value:
            match = re.search(r'(\d+\.?\d*)', value)
            if match:
                return float(match.group(1)) / 1000
        elif 'oz' in value:
            match = re.search(r'(\d+\.?\d*)', value)
            if match:
                return float(match.group(1)) * 0.0283495

        return np.nan

    except Exception as e:
        print(f"Error parsing: {value} -> {e}")
        return np.nan

class DataCleaning():
    '''
    The DataCleaning() class is a stateless class as it has no __init__() method;
    it simply serves as a container for several methods which are used to clean Pandas dataframes.
    The class may be imported into other programs, and instantiated, in order to provide access to said methods.
    '''

    def clean_user_data(self, user_data):
        """
        Clean user data by removing NaN values, and converting date columns to datetime
        """

        # Replace "NULL" string with actual NaN
        user_data = user_data.replace("NULL", np.nan)

        # Convert 'join_date' to datetime
        user_data['join_date'] = pd.to_datetime(user_data['join_date'], format='mixed', errors='coerce')

        # Drop rows with any NaN values
        user_data = user_data.dropna()

        return user_data

    def clean_card_data(self, card_data):
        """
        clean card data by removing nulls and duplicates, filling missing values
        and converting date columns to datetime
        """

        # Replace "NULL" string with actual NaN
        card_data = card_data.replace("NULL", np.nan)

        # Drop rows with any NaN values
        card_data = card_data.dropna()

        # Remove duplicates based on 'card_number' column
        # Keep the first occurrence of each duplicate
        card_data = card_data.drop_duplicates(subset='card_number', keep='first')

        # Convert 'card_number' to string and remove '?' characters
        card_data['card_number'] = card_data['card_number'].astype(str).str.replace('?', '', regex=False)

        # Keep only rows where card_number is all digits
        card_data = card_data[card_data['card_number'].astype(str).str.isnumeric()]

        # Convert 'date_payment_confirmed' to datetime
        card_data['date_payment_confirmed'] = pd.to_datetime(card_data['date_payment_confirmed'], format='mixed', errors='coerce')

        return card_data

    def called_clean_store_data(self, store_data):
        """
        clean store data by removing columns containing no useful information,
        converting dates to datetime, removing non-numeric characters from staff-numbers,
        and removing nulls
        """

        # drop 'lat' column because it contains no useful information
        store_data = store_data.drop(columns=['lat'])

        # drop 'Unnamed' column because it contains no useful information
        store_data = store_data.drop(columns=['Unnamed: 0'])

        # Replace "NULL" string with actual NaN
        store_data = store_data.replace("NULL", np.nan)

        # Convert 'opening_date' to datetime
        store_data['opening_date'] = pd.to_datetime(store_data['opening_date'], format='mixed', errors='coerce')

        # Drop rows having NaT in 'opening_date'
        # This will remove rows where 'opening_date' could not be converted to datetime
        store_data = store_data[store_data['opening_date'].notna()]
        #store_data = store_data.dropna(subset=['opening_date'])

        # Remove any non-numeric characters from 'staff_numbers'
        store_data['staff_numbers'] = store_data['staff_numbers'].astype(str).str.replace(r'\D', '', regex=True)

        # drop index column
        store_data = store_data.drop(columns=['index'])

        # reset index
        store_data = store_data.reset_index(drop=True)

        return store_data

    def convert_product_weights(self, product_data):
        """
        convert product weights to decimal numbers in kg
        """

        # Apply the function to the 'weight' column
        product_data['weight'] = product_data['weight'].apply(extract_weight_kg)

        return product_data

    def clean_products_data(self, product_data):
        """
        clean product data by removing nulls and columns containing no useful information
        """

        # Replace "NULL" string with actual NaN
        product_data = product_data.replace("NULL", np.nan)

        # Drop rows with any NaN values
        product_data = product_data.dropna()

        # drop 'Unnamed' column because it contains no useful information
        product_data = product_data.drop(columns=['Unnamed: 0'])

        # reset index
        product_data = product_data.reset_index(drop=True)

        return product_data

    def clean_orders_data(self, orders_data):
        """
        Clean orders data by removing columns containing no useful information
        """

        # drop 'Unnamed' column because it contains no useful information
        orders_data = orders_data.drop(columns=['Unnamed: 0'])

        # drop 'first_name' column because it contains no useful information
        orders_data = orders_data.drop(columns=['first_name'])
        # drop 'last_name' column because it contains no useful information
        orders_data = orders_data.drop(columns=['last_name'])
        # drop '1' column because it contains no useful information
        orders_data = orders_data.drop(columns=['1'])

        # drop 'index' column because it duplicates the index
        orders_data = orders_data.drop(columns=['index'])

        # reset index
        orders_data = orders_data.reset_index(drop=True)

        return orders_data

    def clean_date_events(self, df):
        """
        Clean date events data by removing duplicates,
        converting time column to datetime,
        and converting date columns to numeric format
        """

        # Replace "NULL" string with actual NaN
        df = df.replace("NULL", np.nan)

        # Convert 'day', 'month', 'year' to numeric format
        df['day'] = pd.to_numeric(df['day'], errors='coerce')
        df['month'] = pd.to_numeric(df['month'], errors='coerce')
        df['year'] = pd.to_numeric(df['year'], errors='coerce')

        # convert 'timestamp' to datetime
        #print(df['timestamp'])
        #import pandas as pd

        df['timestamp'] = pd.to_datetime(df['timestamp'], format='%H:%M:%S', errors='coerce').dt.time
        #df['timestamp'] = pd.to_datetime(df['timestamp'], format='%H:%M:%S', errors='coerce')
        #df['timestamp'] = pd.to_datetime(df['timestamp'], format='mixed', errors='coerce')
        # Drop rows with any NaT values in 'timestamp'
        df = df[df['timestamp'].notna()]
        # Drop rows with any NaN values
        df = df.dropna()

        # reset index
        df = df.reset_index(drop=True)

        return df
