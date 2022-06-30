#!/bin/sh -

TIMESTAMP=$(git log -1 --format='%cd' --date=unix)
MESSAGE=$(git log -1 --format='%s')
EMAIL=$(git log -1 --format='%ae')
NAME=$(git log -1 --format='%an')


PR_URL="https://github.com/${GITHUB_REPOSITORY}/pull/${INPUT_PR}"
COMMENTS_URL="${PR_URL}/comments"

export DEPLOYMENT_NAME=$(dagster-cloud branch-deployment create-or-update \
    --url https://7151-136-24-32-204.ngrok.io/1/prod \
    --api-token "agent:test:hardcoded" \
    --git-repo-name "$GITHUB_REPOSITORY" \
    --branch-name "$GITHUB_HEAD_REF" \
    --branch-url "https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_HEAD_REF}" \
    --pull-request-url "$PR_URL" \
    --commit-hash "$GITHUB_SHA" \
    --timestamp "$TIMESTAMP" \
    --commit-message "$MESSAGE" \
    --author-name "$NAME" \
    --author-email "$EMAIL")

dagster-cloud workspace add-location \
    --url "https://7151-136-24-32-204.ngrok.io/1/${DEPLOYMENT_NAME}" \
    --api-token "agent:test:hardcoded" \
    --location-file "${INPUT_LOCATION_FILE}" \
    --location-name "${INPUT_LOCATION_NAME}" \
    --image "${INPUT_REGISTRY}:${INPUT_IMAGE_TAG}"

python create_or_update_comment.py