#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

help=$(dagster-cloud branch-deployment create-or-update --help)
echo "::set-output name=help::$help"

ls -la

TIMESTAMP=$(git log -1 --format='%cd' --date=unix)
MESSAGE=$(git log -1 --format='%s')
EMAIL=$(git log -1 --format='%ae')
NAME=$(git log -1 --format='%an')
PR_NUMBER=$(gh pr view --json number -q .number)
PR_URL="https://github.com/${GITHUB_REPOSITORY}/pull/${PR_NUMBER}"
if [ $? -eq 1 ]
then
    PR_URL=""
fi
dagster-cloud branch-deployment create-or-update \
    --url https://7151-136-24-32-204.ngrok.io/1/prod \
    --api-token "agent:test:hardcoded" \
    --git-repo-name "$GITHUB_REPOSITORY" \
    --branch-name "$GITHUB_REF_NAME" \
    --branch-url "https://github.com/${GITHUB_REPOSITORY}/tree/${GITHUB_REF_NAME}" \
    --pull-request-url "$PR_URL" \
    --commit-hash "$GITHUB_SHA" \
    --timestamp "$TIMESTAMP" \
    --commit-message "$MESSAGE" \
    --author-name "$NAME" \
    --author-email "$EMAIL"
