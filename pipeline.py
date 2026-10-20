import kfp
from kfp import dsl
from google.cloud import aiplatform

PROJECT_ID = "netflixtitles-512209"
REGION = "us-central1"
BUCKET_NAME = f"{PROJECT_ID}-vertex-pipelines"
PIPELINE_ROOT = f"gs://{BUCKET_NAME}/pipeline_root"

@dsl.component(
    base_image="python:3.11",
    packages_to_install=["google-cloud-bigquery"]
)
def refresh_embeddings_component(project_id: str):
    from google.cloud import bigquery
    # Explicitly set location="US" so the client targets the media_catalog dataset location
    client = bigquery.Client(project=project_id, location="US")
    
    query = """
    CREATE OR REPLACE TABLE `media_catalog.netflix_features` AS
    SELECT
      show_id, type, title, release_year, rating, listed_in, description,
      ml_generate_embedding_result AS title_feature_vector
    FROM ML.GENERATE_EMBEDDING(
      MODEL `media_catalog.embedding_model`,
      (
        SELECT show_id, type, title, release_year, rating, listed_in, description,
          CONCAT('Title: ', IFNULL(title, ''), '; Genres: ', IFNULL(listed_in, ''), '; Description: ', IFNULL(description, '')) AS content
        FROM `media_catalog.netflix_raw`
      ),
      STRUCT(TRUE AS flatten_json_output)
    );
    """
    job = client.query(query)
    job.result()
    print("Feature embedding generation complete.")

@dsl.pipeline(
    name="netflix-recommendation-pipeline",
    description="End-to-End Netflix Catalog Feature & Vector Search Refresh Pipeline"
)
def netflix_pipeline(project_id: str = PROJECT_ID):
    refresh_task = refresh_embeddings_component(project_id=project_id)

if __name__ == "__main__":
    kfp.compiler.Compiler().compile(
        pipeline_func=netflix_pipeline,
        package_path="netflix_pipeline.yaml"
    )
    
    aiplatform.init(
        project=PROJECT_ID,
        location=REGION,
        staging_bucket=f"gs://{BUCKET_NAME}"
    )
    
    job = aiplatform.PipelineJob(
        display_name="netflix-catalog-feature-pipeline",
        template_path="netflix_pipeline.yaml",
        pipeline_root=PIPELINE_ROOT,
    )
    job.submit()
    print("Vertex AI Pipeline job successfully submitted to execution queue!")
