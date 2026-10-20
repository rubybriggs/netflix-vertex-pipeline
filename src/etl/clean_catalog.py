import pandas as pd
import numpy as np
from google.cloud import bigquery
from google.cloud import storage

def clean_netflix_data(input_gcs_path: str):
    df = pd.read_csv(input_gcs_path)

    misaligned_mask = df['rating'].str.contains('min', na=False)
    df.loc[misaligned_mask, 'duration'] = df.loc[misaligned_mask, 'rating']
    df.loc[misaligned_mask, 'rating'] = 'NR'

    df['director'] = df['director'].fillna('Unknown')
    df['cast'] = df['cast'].fillna('Unknown')
    df['country'] = df['country'].fillna('Unknown')
    df['rating'] = df['rating'].fillna('NR')
    df.dropna(subset=['date_added'], inplace=True)

    df['date_added'] = pd.to_datetime(df['date_added'].str.strip(), format='%B %d, %Y', errors='coerce')

    return df

GCS_PATH = "gs://mustseemovies-mlops-data/raw/mustseemovies.csv"

if __name__ == "__main__":
    print("Reading and cleaning dataset from GCS...")
    df_clean = clean_netflix_data(GCS_PATH)
    print("Successfully processed data!")
    print(f"Total Rows: {len(df_clean)}")
    print(df_clean.head())

