import great_expectations as ge
from google.cloud import bigquery

def run_quality_suite():
    # 1. Fetch cleaned dataset from BigQuery
    client = bigquery.Client(project="mustseemovies")
    query = "SELECT * FROM `mustseemovies.mustseemovies.cleaned`"
    df = client.query(query).to_dataframe()

    # 2. Get ephemeral context (v1.0+)
    context = ge.get_context(mode="ephemeral")

    # 3. Add Pandas Data Source and Asset
    datasource = context.data_sources.add_pandas("pandas_datasource")
    asset = datasource.add_dataframe_asset("cleaned_asset")
    
    # 4. Build batch request and retrieve validator
    batch_request = asset.build_batch_request(options={"dataframe": df})
    validator = context.get_validator(
        batch_request=batch_request,
        create_expectation_suite_with_name="quality_suite"
    )

    # 5. Define assertions
    validator.expect_column_values_to_be_unique("show_id")
    validator.expect_column_values_to_not_be_null("title")
    validator.expect_column_values_to_be_in_set("type", ["Movie", "TV Show"])
    validator.expect_column_values_to_not_match_regex("rating", r"\d+\s*min")
    validator.expect_column_values_to_be_between("release_year", 1920, 2026)

    # 6. Validate
    results = validator.validate()

    if results.success:
        print(" DATA QUALITY SUITE PASSED: All assertions satisfied.")
    else:
        print(" DATA QUALITY SUITE FAILED: Review quality reports.")

if __name__ == "__main__":
    run_quality_suite()
