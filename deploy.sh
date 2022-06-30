#!/bin/sh -

echo $INPUT_LOCATION

python -c "import json; print(json.load(${INPUT_LOCATION}))"

TIMESTAMP=$(git log -1 --format='%cd' --date=unix)
MESSAGE=$(git log -1 --format='%s')
EMAIL=$(git log -1 --format='%ae')
NAME=$(git log -1 --format='%an')

PR_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/${INPUT_PR}"
export GITHUB_RUN_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"
BRANCH_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/tree/${GITHUB_HEAD_REF}"

COMMENTS_URL="${PR_URL}/comments"

if [ -z $DAGSTER_CLOUD_URL ]; then
  export DAGSTER_CLOUD_URL="https://dagster.cloud/${INPUT_ORGANIZATION_ID}"
fi

export DEPLOYMENT_NAME=$(dagster-cloud branch-deployment create-or-update \
    --url "$DAGSTER_CLOUD_URL" \
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


dagster-cloud workspace add-location \
    --url "${DAGSTER_CLOUD_URL}/${DEPLOYMENT_NAME}" \
    --api-token "$DAGSTER_CLOUD_API_TOKEN" \
    --location-file "${INPUT_LOCATION_FILE}" \
    --location-name "${INPUT_LOCATION_NAME}" \
    --image "${INPUT_REGISTRY}:${INPUT_IMAGE_TAG}"
