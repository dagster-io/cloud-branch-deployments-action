#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

help=$(dagster-cloud branch-deployment create-or-update --help)
echo "::set-output name=help::$help"

cd /github/home

TIMESTAMP=$(git log -1 --format=%cd --date=unix)
echo $TIMESTAMP

dagster-cloud-branch-deployment create-or-update \
    --url https://7151-136-24-32-204.ngrok.io/1/prod/ \
    --api-token "agent:test:hardcoded" \
    --git-repo-name $GITHUB_REPOSITORY \
    --branch-name $GITHUB_REF_NAME \
    --commit-hash $GITHUB_SHA \
    --timestamp $TIMESTAMP
