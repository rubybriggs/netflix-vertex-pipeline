from google.cloud import aiplatform

PROJECT_ID = "mustseemovies"
REGION = "us-central1"
BUCKET_NAME = f"gs://{PROJECT_ID}-mlops-data"
PIPELINE_ROOT = f"{BUCKET_NAME}/pipeline_root/"

aiplatform.init(
    project=PROJECT_ID, 
    location=REGION,
    staging_bucket=BUCKET_NAME
)

job = aiplatform.PipelineJob(
    display_name="mustseemovies-catalog-mlops-run-v2",
    template_path="pipeline.yaml",
    pipeline_root=PIPELINE_ROOT,
    parameter_values={
        "project_id": PROJECT_ID,
        "dataset_id": "mustseemovies",
        "table_id": "cleaned"
    },
    enable_caching=False
)

job.submit()
print("PIPELINE SUBMITTED SUCCESSFULLY WITHOUT BUCKET CONFLICT!")
