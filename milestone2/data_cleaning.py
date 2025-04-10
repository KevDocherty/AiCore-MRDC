import pandas as pd
import numpy as np

class DataCleaning():

    def clean_user_data(self, user_data):
        """
        Clean user data by removing NaN values, and converting date columns to datetime
        """
        # Remove duplicates
        #user_data = user_data.drop_duplicates()

        # Fill missing values
        #user_data.fillna(method='ffill', inplace=True)

        # Replace "NULL" string with actual NaN
        user_data = user_data.replace("NULL", np.nan)

        # Convert 'join_date' to datetime
        user_data['join_date'] = pd.to_datetime(user_data['join_date'], format='mixed', errors='coerce')

        # Drop rows with any NaN values
        user_data = user_data.dropna()

        return user_data

    def clean_card_data(self, card_data):
        """
        Clean card data by removing duplicates and filling missing values.
        """

        # Replace "NULL" string with actual NaN
        card_data = card_data.replace("NULL", np.nan)

        # Drop rows with any NaN values
        card_data = card_data.dropna()

        # Remove duplicates
        card_data = card_data.drop_duplicates()

        # Remove duplicates based on 'card_number' column
        # Keep the first occurrence of each duplicate
        card_data = card_data.drop_duplicates(subset='card_number', keep='first')

        # Keep only rows where card_number is all digits
        card_data = card_data[card_data['card_number'].astype(str).str.isnumeric()]

        # Convert 'date_payment_confirmed' to datetime
        card_data['date_payment_confirmed'] = pd.to_datetime(card_data['date_payment_confirmed'], format='mixed', errors='coerce')

        # Drop rows with any NaN values
        card_data = card_data.dropna()

        return card_data
