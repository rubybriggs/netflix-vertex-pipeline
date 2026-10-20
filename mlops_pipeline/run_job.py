from google.cloud import aiplatform

PROJECT_ID = "mustseemovies"
REGION = "us-central1"
PIPELINE_ROOT = f"gs://{PROJECT_ID}-mlops-data/pipeline_root/"

aiplatform.init(project=PROJECT_ID, location=REGION)

job = aiplatform.PipelineJob(
    display_name="netflix-catalog-mlops-run-v1",
    template_path="pipeline.yaml",
    pipeline_root=PIPELINE_ROOT,
    parameter_values={
        "project_id": PROJECT_ID,
        "dataset_id": "mustseemovies",
        "table_id": "cleaned"
    },
    enable_caching=True
)

job.submit()
print(" PIPELINE SUBMITTED: View status in Vertex AI Console.")
