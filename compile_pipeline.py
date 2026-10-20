from kfp import dsl, compiler

@dsl.component
def prepare_mustseemovies_data():
    print("Preparing mustseemovies dataset for MLOps pipeline...")

@dsl.pipeline(
    name="mustseemovies-mlops-pipeline",
    description="An end-to-end MLOps pipeline for mustseemovies dataset."
)
def pipeline_definition():
    prepare_mustseemovies_data()

if __name__ == "__main__":
    compiler.Compiler().compile(
        pipeline_func=pipeline_definition,
        package_path="pipeline.json"
    )
    print("pipeline.json successfully created!")
