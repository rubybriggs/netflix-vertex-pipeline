from kfp.dsl import component, Input, Output, Dataset, Model, Metrics

@component(
    base_image="python:3.10",
    packages_to_install=["pandas", "scikit-learn", "joblib"]
)
def evaluate_model_component(
    test_dataset: Input[Dataset],
    model_artifact: Input[Model],
    metrics: Output[Metrics]
):
    import pandas as pd
    import joblib
    from sklearn.metrics import accuracy_score, precision_score, recall_score
    
    # 1. Load test set & trained model
    test_df = pd.read_csv(test_dataset.path)
    y_test = test_df['type'].map({'Movie': 1, 'TV Show': 0})
    
    text_cols = ['show_id', 'type', 'title', 'director', 'cast', 'country', 'date_added', 'rating', 'listed_in', 'description']
    X_test = test_df.drop(columns=[col for col in text_cols if col in test_df.columns])
    X_test = X_test.fillna(0)
    
    # Load artifact path
    clf = joblib.load(model_artifact.path)
    
    # 2. Compute evaluation metrics
    y_pred = clf.predict(X_test)
    acc = accuracy_score(y_test, y_pred)
    prec = precision_score(y_test, y_pred, average='binary')
    rec = recall_score(y_test, y_pred, average='binary')
    
    # 3. Log metrics to Vertex AI Pipelines metadata
    metrics.log_metric("accuracy", float(acc))
    metrics.log_metric("precision", float(prec))
    metrics.log_metric("recall", float(rec))
    
    print(f"Metrics Logged — Accuracy: {acc:.4f}, Precision: {prec:.4f}, Recall: {rec:.4f}")
