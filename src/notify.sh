#!/bin/bash -

# Load JSON-encoded location info into env vars
# This produces the env vars
# INPUT_NAME, INPUT_LOCATION_FILE, INPUT_REGISTRY
source $(python /expand_json_env.py)
if [ -z $INPUT_LOCATION_NAME ]; then
    INPUT_LOCATION_NAME="${INPUT_NAME}"
fi

PR_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/${INPUT_PR}"
export GITHUB_RUN_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"

COMMENTS_URL="${PR_URL}/comments"

if [ -z $DAGSTER_CLOUD_URL ]; then
  export DAGSTER_CLOUD_URL="https://dagster.cloud/${INPUT_ORGANIZATION_ID}"
fi

export INPUT_LOCATION_NAME=$INPUT_LOCATION_NAME
python /create_or_update_comment.py