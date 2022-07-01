#!/bin/bash -

# Load JSON-encoded location info into env vars
# This produces the env vars
# LOCATION_NAME, LOCATION_LOCATION_FILE, LOCATION_REGISTRY
source $(python /expand_json_env.py)

if [ -z $LOCATION_REGISTRY ]; then
    LOCATION_REGISTRY="${!LOCATION_REGISTRY_ENV}"
fi

# Extract git metadata
TIMESTAMP=$(git log -1 --format='%cd' --date=unix)
MESSAGE=$(git log -1 --format='%s')
EMAIL=$(git log -1 --format='%ae')
NAME=$(git log -1 --format='%an')

# Assemble github URLs
PR_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/${INPUT_PR}"
BRANCH_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/tree/${GITHUB_HEAD_REF}"

if [ -z $DAGSTER_CLOUD_URL ]; then
  export DAGSTER_CLOUD_URL="https://dagster.cloud/${INPUT_ORGANIZATION_ID}"
fi

export DEPLOYMENT_NAME=$(dagster-cloud branch-deployment create-or-update \
    --url "${DAGSTER_CLOUD_URL}" \
    --api-token "$DAGSTER_CLOUD_API_TOKEN" \
    --git-repo-name "$GITHUB_REPOSITORY" \
    --branch-name "$GITHUB_HEAD_REF" \
    --branch-url "$BRANCH_URL" \
    --pull-request-url "$PR_URL" \
    --commit-hash "$GITHUB_SHA" \
    --timestamp "$TIMESTAMP" \
    --commit-message "$MESSAGE" \
    --author-name "$NAME" \
    --author-email "$EMAIL")

echo "::set-output name=deployment::${DEPLOYMENT_NAME}"

dagster-cloud workspace add-location \
    --url "${DAGSTER_CLOUD_URL}/${DEPLOYMENT_NAME}" \
    --api-token "$DAGSTER_CLOUD_API_TOKEN" \
    --location-file "${LOCATION_LOCATION_FILE}" \
    --location-name "${LOCATION_NAME}" \
    --image "${LOCATION_REGISTRY}:${INPUT_IMAGE_TAG}"
