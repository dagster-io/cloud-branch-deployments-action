#!/bin/sh -

TIMESTAMP=$(git log -1 --format='%cd' --date=unix)
MESSAGE=$(git log -1 --format='%s')
EMAIL=$(git log -1 --format='%ae')
NAME=$(git log -1 --format='%an')

PR_URL="https://github.com/${GITHUB_REPOSITORY}/pull/${INPUT_PR}"
COMMENTS_URL="${PR_URL}/comments"

if [ -z $INPUT_DAGSTER_CLOUD_URL ]; then
  export INPUT_DAGSTER_CLOUD_URL="https://dagster.cloud/${INPUT_ORGANIZATION_ID}"
fi

export DEPLOYMENT_NAME=$(dagster-cloud branch-deployment create-or-update \
    --url "$INPUT_DAGSTER_CLOUD_URL" \
    --api-token "$DAGSTER_CLOUD_API_TOKEN" \
    --git-repo-name "$GITHUB_REPOSITORY" \
    --branch-name "$GITHUB_HEAD_REF" \
    --branch-url "https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_HEAD_REF}" \
    --pull-request-url "$PR_URL" \
    --commit-hash "$GITHUB_SHA" \
    --timestamp "$TIMESTAMP" \
    --commit-message "$MESSAGE" \
    --author-name "$NAME" \
    --author-email "$EMAIL")

if [ $? -ne 0 ]; then
    export INPUT_ACTION="failed"
    python create_or_update_comment.py
    exit 1
fi

dagster-cloud workspace add-location \
    --url "${INPUT_DAGSTER_CLOUD_URL}/${DEPLOYMENT_NAME}" \
    --api-token "$DAGSTER_CLOUD_API_TOKEN" \
    --location-file "${INPUT_LOCATION_FILE}" \
    --location-name "${INPUT_LOCATION_NAME}" \
    --image "${INPUT_REGISTRY}:${INPUT_IMAGE_TAG}"

if [ $? -ne 0 ]; then
    export INPUT_ACTION="failed"
    python create_or_update_comment.py
    exit 1
fi

python create_or_update_comment.py