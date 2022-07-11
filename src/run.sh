#!/bin/bash -

# Load JSON-encoded location info into env vars
# This produces the env vars
# LOCATION_NAME, LOCATION_LOCATION_FILE, LOCATION_REGISTRY
source $(python /expand_json_env.py)

if [ -z $LOCATION_REGISTRY ]; then
    LOCATION_REGISTRY="${!LOCATION_REGISTRY_ENV}"
fi

if [ -z $DAGSTER_CLOUD_URL ]; then
    if [ -z $INPUT_DAGSTER_CLOUD_URL ]; then
        export DAGSTER_CLOUD_URL="https://dagster.cloud/${INPUT_ORGANIZATION_ID}"
    else
        export DAGSTER_CLOUD_URL="${INPUT_DAGSTER_CLOUD_URL}"
    fi
fi

RUN_ID=$(
    dagster-cloud job launch \
    --url "${DAGSTER_CLOUD_URL}/${INPUT_DEPLOYMENT}" \
    --api-token "$DAGSTER_CLOUD_API_TOKEN" \
    --location "${LOCATION_NAME}" \
    --repository "${INPUT_REPOSITORY}" \
    --job "${INPUT_JOB}" \
    --tags "${INPUT_TAGS_JSON}" \
    --config-json "${INPUT_CONFIG_JSON}"
)

echo "::set-output name=run_id::${RUN_ID}"
