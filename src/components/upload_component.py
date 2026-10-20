from kfp.dsl import component, Input, Output, Model

@component(
    base_image="python:3.10",
    packages_to_install=["google-cloud-aiplatform"]
)
def register_model_component(
    project_id: str,
    region: str,
    model_display_name: str,
    model_artifact: Input[Model]
):
    from google.cloud import aiplatform

    aiplatform.init(project=project_id, location=region)

    # Extract GCS artifact URI directory
    gcs_artifact_uri = model_artifact.uri.rsplit('/', 1)[0]

    # Upload & register model in Vertex AI Model Registry
    registered_model = aiplatform.Model.upload(
        display_name=model_display_name,
        artifact_uri=gcs_artifact_uri,
        serving_container_image_uri="us-docker.pkg.dev/vertex-ai/prediction/sklearn-cpu.1-3:latest",
        description="MustSeeMovies catalog classifier registered via Vertex AI Pipeline"
    )

    print(f"Model Registered Successfully! Resource Name: {registered_model.resource_name}")
