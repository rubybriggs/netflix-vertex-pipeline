import kfp
from kfp import dsl
from src.components.prep_component import preprocess_netflix_data
from src.components.train_component import train_model_component
from src.components.eval_component import evaluate_model_component
from src.components.upload_component import register_model_component

PROJECT_ID = "mustseemovies"
BUCKET_NAME = f"gs://{PROJECT_ID}-mlops-bucket-15456649201"

@dsl.pipeline(
    name="netflix-mlops-pipeline",
    description="End-to-end training, evaluation, and registry pipeline.",
    pipeline_root=f"{BUCKET_NAME}/pipeline_root/"
)
def netflix_pipeline(
    project_id: str = PROJECT_ID,
    region: str = "us-central1",
    dataset_id: str = "mustseemovies",
    table_id: str = "cleaned"
):
    # Step 1: Preprocessing
    prep_task = preprocess_netflix_data(
        project_id=project_id,
        dataset_id=dataset_id,
        table_id=table_id
    )
    
    # Step 2: Training
    train_task = train_model_component(
        train_dataset=prep_task.outputs['train_dataset']
    )
    
    # Step 3: Evaluation
    eval_task = evaluate_model_component(
        test_dataset=prep_task.outputs['test_dataset'],
        model_artifact=train_task.outputs['model_artifact']
    )

    # Step 4: Register Model in Vertex AI Model Registry
    register_task = register_model_component(
        project_id=project_id,
        region=region,
        model_display_name="netflix-catalog-classifier",
        model_artifact=train_task.outputs['model_artifact']
    )

if __name__ == "__main__":
    compiler = kfp.compiler.Compiler()
    compiler.compile(
        pipeline_func=netflix_pipeline,
        package_path="pipeline.yaml"
    )
    print("PIPELINE COMPILED WITH UNIQUE BUCKET ROOT.")
