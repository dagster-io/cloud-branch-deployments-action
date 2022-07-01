#!/bin/bash -

# Load JSON-encoded location info into env vars
# This produces the env vars
# LOCATION_NAME, LOCATION_LOCATION_FILE, LOCATION_REGISTRY
source $(python expand_json_env.py)

PR_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/${INPUT_PR}"
export GITHUB_RUN_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"

COMMENTS_URL="${PR_URL}/comments"

if [ -z $DAGSTER_CLOUD_URL ]; then
  export DAGSTER_CLOUD_URL="https://dagster.cloud/${INPUT_ORGANIZATION_ID}"
fi

export LOCATION_NAME=$LOCATION_NAME
python create_or_update_comment.py