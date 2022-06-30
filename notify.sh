#!/bin/sh -

TIMESTAMP=$(git log -1 --format='%cd' --date=unix)
MESSAGE=$(git log -1 --format='%s')
EMAIL=$(git log -1 --format='%ae')
NAME=$(git log -1 --format='%an')

PR_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/pull/${INPUT_PR}"
export GITHUB_RUN_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}"
BRANCH_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/tree/${GITHUB_HEAD_REF}"

COMMENTS_URL="${PR_URL}/comments"

if [ -z $INPUT_DAGSTER_CLOUD_URL ]; then
  export INPUT_DAGSTER_CLOUD_URL="https://dagster.cloud/${INPUT_ORGANIZATION_ID}"
fi

python create_or_update_comment.py