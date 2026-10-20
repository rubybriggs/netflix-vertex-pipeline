from kfp.dsl import component, Output, Dataset

@component(
    base_image="python:3.10",
    packages_to_install=["google-cloud-bigquery", "pandas", "scikit-learn", "db-dtypes"]
)
def preprocess_mustseemovies_data(
    project_id: str,
    dataset_id: str,
    table_id: str,
    train_dataset: Output[Dataset],
    test_dataset: Output[Dataset]
):
    import pandas as pd
    from google.cloud import bigquery
    from sklearn.model_selection import train_test_split

    client = bigquery.Client(project=project_id)
    query = f"SELECT * FROM `{project_id}.{dataset_id}.{table_id}`"
    df = client.query(query).to_dataframe()

    train_df, test_df = train_test_split(df, test_size=0.2, random_state=42)

    train_df.to_csv(train_dataset.path, index=False)
    test_df.to_csv(test_dataset.path, index=False)
    print("MustSeeMovies data split and preprocessed successfully.")
