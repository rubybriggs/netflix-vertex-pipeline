    """
    job = client.query(query)
    job.result()
    print("Feature embedding refresh task completed successfully.")

@dsl.pipeline(
    name="netflix-recommendation-pipeline",
    description="Automated feature pipeline refreshing catalog embeddings in BigQuery"
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
        staging_bucket=f"gs://{PROJECT_ID}-vertex-pipelines"
    )
    
    job = aiplatform.PipelineJob(
        display_name="netflix-catalog-embedding-refresh",
        template_path="netflix_pipeline.yaml",
        pipeline_root=PIPELINE_ROOT,
    )
    job.run(sync=False)
    print("Vertex AI Pipeline job successfully submitted to execution queue!")
EOF

python3 pipeline.py
cat << 'EOF' > pipeline.py
import kfp
from kfp import dsl
from google.cloud import aiplatform

PROJECT_ID = "netflixtitles-512209"
REGION = "us-central1"
PIPELINE_ROOT = f"gs://{PROJECT_ID}-vertex-pipelines/pipeline_root"

@dsl.component(
    base_image="python:3.11",
    packages_to_install=["google-cloud-bigquery"]
)
def refresh_embeddings_component(project_id: str):
    from google.cloud import bigquery
    client = bigquery.Client(project=project_id)
    
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
    
    # Initialize with staging_bucket set to bypass bucket validation errors
    aiplatform.init(
        project=PROJECT_ID, 
        location=REGION,
        staging_bucket=f"gs://{PROJECT_ID}-vertex-pipelines"
    )
    
    job = aiplatform.PipelineJob(
        display_name="netflix-catalog-feature-pipeline",
        template_path="netflix_pipeline.yaml",
        pipeline_root=PIPELINE_ROOT,
    )
    job.run(sync=False)
    print("Vertex AI Pipeline job submitted successfully!")
EOF

python3 pipeline.py
cat << 'EOF' > pipeline.py
import kfp
from kfp import dsl
from google.cloud import aiplatform

PROJECT_ID = "netflixtitles-512209"
REGION = "us"
PIPELINE_ROOT = f"gs://{PROJECT_ID}-vertex-pipelines/pipeline_root"

@dsl.component(
    base_image="python:3.11",
    packages_to_install=["google-cloud-bigquery"]
)
def refresh_embeddings_component(project_id: str):
    from google.cloud import bigquery
    client = bigquery.Client(project=project_id)
    
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
        staging_bucket=f"gs://{PROJECT_ID}-vertex-pipelines",
        output_artifacts_gcs_dir=f"gs://{PROJECT_ID}-vertex-pipelines/artifacts"
    )
    
    job = aiplatform.PipelineJob(
        display_name="netflix-catalog-feature-pipeline",
        template_path="netflix_pipeline.yaml",
        pipeline_root=PIPELINE_ROOT,
    )
    job.run(sync=False)
    print("Vertex AI Pipeline job successfully submitted to execution queue!")
EOF

python3 pipeline.py
cat << 'EOF' > pipeline.py
import kfp
from kfp import dsl
from google.cloud import aiplatform

PROJECT_ID = "netflixtitles-512209"
REGION = "us-central1"
PIPELINE_ROOT = f"gs://{PROJECT_ID}-vertex-pipelines/pipeline_root"

@dsl.component(
    base_image="python:3.11",
    packages_to_install=["google-cloud-bigquery"]
)
def refresh_embeddings_component(project_id: str):
    from google.cloud import bigquery
    client = bigquery.Client(project=project_id)
    
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
    
    # Initialize Vertex AI SDK with a valid regional endpoint (us-central1) and staging bucket
    aiplatform.init(
        project=PROJECT_ID,
        location=REGION,
        staging_bucket=f"gs://{PROJECT_ID}-vertex-pipelines"
    )
    
    job = aiplatform.PipelineJob(
        display_name="netflix-catalog-feature-pipeline",
        template_path="netflix_pipeline.yaml",
        pipeline_root=PIPELINE_ROOT,
    )
    job.run(sync=False)
    print("Vertex AI Pipeline job successfully submitted to execution queue!")
EOF

python3 pipeline.py
# Create connection in us-central1
bq mk --connection   --location=us-central1   --project_id=netflixtitles-512209   --connection_type=CLOUD_RESOURCE   vertex_llm_connection_us_central1
# Fetch the service account ID for the new connection
MEMBER_SA=$(bq show --location=us-central1 --connection netflixtitles-512209.us-central1.vertex_llm_connection_us_central1 | grep "serviceAccountId" | awk -F '"' '{print $4}')
# Grant Vertex AI User permissions to the new service account
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="serviceAccount:${MEMBER_SA}"   --role="roles/aiplatform.user"
# Create connection in US region
bq mk --connection   --location=US   --project_id=netflixtitles-512209   --connection_type=CLOUD_RESOURCE   vertex_llm_connection
# Get Service Account & grant IAM role
MEMBER_SA=$(bq show --location=US --connection netflixtitles-512209.US.vertex_llm_connection | grep "serviceAccountId" | awk -F '"' '{print $4}')
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="serviceAccount:${MEMBER_SA}"   --role="roles/aiplatform.user"
CREATE OR REPLACE MODEL `media_catalog.embedding_model`
REMOTE WITH CONNECTION `netflixtitles-512209.US.vertex_llm_connection`
OPTIONS(ENDPOINT = 'text-embedding-005');
cat << 'EOF' > pipeline.py
import kfp
from kfp import dsl
from google.cloud import aiplatform

PROJECT_ID = "netflixtitles-512209"
REGION = "us-central1"
PIPELINE_ROOT = f"gs://{PROJECT_ID}-vertex-pipelines/pipeline_root"

@dsl.component(
    base_image="python:3.11",
    packages_to_install=["google-cloud-bigquery"]
)
def refresh_embeddings_component(project_id: str):
    from google.cloud import bigquery
    client = bigquery.Client(project=project_id)
    
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
        staging_bucket=f"gs://{PROJECT_ID}-vertex-pipelines"
    )
    
    job = aiplatform.PipelineJob(
        display_name="netflix-catalog-feature-pipeline",
        template_path="netflix_pipeline.yaml",
        pipeline_root=PIPELINE_ROOT,
    )
    job.run(sync=False)
    print("Vertex AI Pipeline job successfully submitted to execution queue!")
EOF

python3 pipeline.py
nano pipeline.py
python3 pipeline.py
nano pipeline.py
python3 pipeline.py
gcloud iam service-accounts add-iam-policy-binding   469130656234-compute@developer.gserviceaccount.com   --member="user:rubybriggs07@gmail.com"   --role="roles/iam.serviceAccountUser"   --project="netflixtitles-512209"
# 1. Enable Compute Engine API (this creates the default compute service account)
gcloud services enable compute.googleapis.com --project=netflixtitles-512209
# 2. Grant yourself Service Account User role at the project level
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="user:rubybriggs07@gmail.com"   --role="roles/iam.serviceAccountUser"
python3 pipeline.py
gcloud ai pipeline-jobs list   --region=us-central1   --project=netflixtitles-512209
gcloud ai pipeline-jobs describe netflix-recommendation-pipeline-20261020104421   --region=us-central1   --project=netflixtitles-512209
\gcloud ai pipeline-jobs describe netflix-recommendation-pipeline-20261020104421   --region=us-central1   --project=netflixtitles-512209
# List jobs
gcloud ai-platform jobs list   --region=us-central1   --project=netflixtitles-512209
# Describe your specific pipeline run
gcloud ai-platform jobs describe netflix-recommendation-pipeline-20261020104421   --region=us-central1   --project=netflixtitles-512209
python3 -c "
from google.cloud import aiplatform

aiplatform.init(project='netflixtitles-512209', location='us-central1')
job = aiplatform.PipelineJob.get('projects/469130656234/locations/us-central1/pipelineJobs/netflix-recommendation-pipeline-20261020104421')
print(f'Pipeline State: {job.state}')
"
python3 -c "
from google.cloud import aiplatform
aiplatform.init(project='netflixtitles-512209', location='us-central1')
job = aiplatform.PipelineJob.get('projects/469130656234/locations/us-central1/pipelineJobs/netflix-recommendation-pipeline-20261020104421')
print(f'Pipeline Name: {job.display_name}')
print(f'State Enum:    {job.state.name}')
print(f'Start Time:    {job.start_time}')
print(f'End Time:      {job.end_time}')
"
python3 -c "
from google.cloud import aiplatform

aiplatform.init(project='netflixtitles-512209', location='us-central1')
job = aiplatform.PipelineJob.get('projects/469130656234/locations/us-central1/pipelineJobs/netflix-recommendation-pipeline-20261020104421')

print('Error Details:', job.error)
"
python3 -c "
from google.cloud import aiplatform

aiplatform.init(project='netflixtitles-512209', location='us-central1')
job = aiplatform.PipelineJob.get('projects/469130656234/locations/us-central1/pipelineJobs/netflix-recommendation-pipeline-20261020104421')

print('Error Message:', job.gca_resource.error.message)
"
# 1. Ensure the Vertex AI API is fully initialized and default metadata store is created
gcloud services enable aiplatform.googleapis.com --project=netflixtitles-512209
# 2. Grant Vertex AI Admin role to your user account
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="user:rubybriggs07@gmail.com"   --role="roles/aiplatform.admin"
# 3. Grant Vertex AI Service Agent permissions to the default compute service account
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="serviceAccount:469130656234-compute@developer.gserviceaccount.com"   --role="roles/aiplatform.serviceAgent"
python3 pipeline.py
python3 -c "
from google.cloud import aiplatform

aiplatform.init(project='netflixtitles-512209', location='us-central1')
jobs = aiplatform.PipelineJob.list(project='netflixtitles-512209', location='us-central1', order_by='create_time desc')
latest_job = jobs[0]

print(f'Latest Job ID: {latest_job.name}')
print(f'State:         {latest_job.state.name}')
"
gcloud config list
ls -la
# 1. Ensure the Vertex AI API is fully initialized and default metadata store is created
gcloud services enable aiplatform.googleapis.com --project=netflixtitles-512209
# 2. Grant Vertex AI Admin role to your user account
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="user:rubybriggs07@gmail.com"   --role="roles/aiplatform.admin"
# 3. Grant Vertex AI Service Agent permissions to the default compute service account
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="serviceAccount:469130656234-compute@developer.gserviceaccount.com"   --role="roles/aiplatform.serviceAgent"
python3 pipeline.py
from google.cloud import aiplatform
aiplatform.init(
)
from google.cloud import aiplatform
aiplatform.init(
)
nano pipeline.py
gcloud storage buckets create gs://netflixtitles-512209-my-custom-pipeline-bucket --location=us-central1
nano pipeline.py
python3 pipeline.py
gcloud logging read 'resource.type="ml_job" AND resource.labels.job_id="225846461842985058304"'   --project=469130656234   --limit=20   --format="value(textPayload)"
# Grant BigQuery Admin and Vertex AI User to default Compute service account
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="serviceAccount:469130656234-compute@developer.gserviceaccount.com"   --role="roles/bigquery.admin"
gcloud projects add-iam-policy-binding netflixtitles-512209   --member="serviceAccount:469130656234-compute@developer.gserviceaccount.com"   --role="roles/aiplatform.user"
cat << 'EOF' > pipeline.py
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
EOF

python3 pipeline.py
SELECT 
FROM `media_catalog.netflix_features`
LIMIT 5;
python3 -c "
from google.cloud import aiplatform

PROJECT_ID = 'netflixtitles-512209'
REGION = 'us-central1'
PIPELINE_ROOT = f'gs://{PROJECT_ID}-vertex-pipelines/pipeline_root'

aiplatform.init(project=PROJECT_ID, location=REGION)

# Initialize pipeline job object from compiled YAML
pipeline_job = aiplatform.PipelineJob(
    display_name='netflix-weekly-embedding-refresh',
    template_path='netflix_pipeline.yaml',
    pipeline_root=PIPELINE_ROOT,
)

# Create production schedule using PipelineJobSchedule
schedule = aiplatform.PipelineJobSchedule(
    pipeline_job=pipeline_job,
    display_name='weekly-catalog-refresh-schedule',
)

# Activate schedule with cron expression
schedule.create(
    cron='0 0 * * 0',
    max_concurrent_run_count=1,
)

print('Production pipeline recurring schedule active!')
"
python3 -c "
from google.cloud import aiplatform

PROJECT_ID = 'netflixtitles-512209'
REGION = 'us-central1'
PIPELINE_ROOT = f'gs://{PROJECT_ID}-vertex-pipelines/pipeline_root'

aiplatform.init(project=PROJECT_ID, location=REGION)

job = aiplatform.PipelineJob(
    display_name='netflix-weekly-embedding-refresh',
    template_path='netflix_pipeline.yaml',
    pipeline_root=PIPELINE_ROOT,
)

# Schedule to run every Sunday at midnight
job.create_schedule(
    cron='0 0 * * 0',
    display_name='weekly-catalog-refresh-schedule',
    start_time=None,
    end_time=None,
)
print('Production pipeline recurring schedule active!')
"
python3 -c "
from google.cloud import aiplatform
aiplatform.init(project='netflixtitles-512209', location='us-central1')
schedules = aiplatform.PipelineJobSchedule.list()
for s in schedules:
    print(f'Schedule Name: {s.display_name} | State: {s.state.name} | Cron: {s.cron}')
"
python3 -c "
from google.cloud import aiplatform

aiplatform.init(project='netflixtitles-512209', location='us-central1')
schedules = aiplatform.PipelineJobSchedule.list()

if len(schedules) > 1:
    print(f'Found {len(schedules)} schedules. Cleaning up duplicates...')
    # Keep the first schedule and delete the rest
    for s in schedules[1:]:
        print(f'Deleting schedule ID: {s.name}')
        s.delete()
    print('Cleanup complete.')
else:
    print('Only one schedule active. No action needed.')
"
python3 -c "
from google.cloud import aiplatform
aiplatform.init(project='netflixtitles-512209', location='us-central1')
schedules = aiplatform.PipelineJobSchedule.list()
for s in schedules:
    print(f'Schedule Name: {s.display_name} | State: {s.state.name} | Cron: {s.cron}')
"
git config --global user.name "ruby briggs"
git config --global user.email "rubybriggs07@gmail.com"
git config --list
