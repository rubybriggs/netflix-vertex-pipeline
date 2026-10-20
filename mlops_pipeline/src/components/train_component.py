from kfp.dsl import component, Input, Output, Dataset, Model

@component(
    base_image="python:3.10",
    packages_to_install=["pandas", "scikit-learn", "joblib"]
)
def train_model_component(
    train_dataset: Input[Dataset],
    model_artifact: Output[Model]
):
    import pandas as pd
    import joblib
    from sklearn.ensemble import RandomForestClassifier
    
    # 1. Load train dataset artifact
    df = pd.read_csv(train_dataset.path)
    
    # 2. Separate features and target column ('type')
    # Explicitly map text labels to numbers to prevent ValueError
    y_train = df['type'].map({'Movie': 1, 'TV Show': 0})
    
    # Drop target and non-numeric text descriptive features for basic modeling
    text_cols = ['show_id', 'type', 'title', 'director', 'cast', 'country', 'date_added', 'rating', 'listed_in', 'description']
    X_train = df.drop(columns=[col for col in text_cols if col in df.columns])
    
    # Fill any remaining null numeric values safely
    X_train = X_train.fillna(0)
    
    # 3. Train Model
    clf = RandomForestClassifier(n_estimators=100, max_depth=5, random_state=42)
    clf.fit(X_train, y_train)
    
    # 4. Save serialized model artifact directly
    joblib.dump(clf, model_artifact.path)
