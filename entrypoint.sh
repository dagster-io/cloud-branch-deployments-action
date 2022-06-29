#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

help=$(dagster-cloud branch-deployment create-or-update --help)
echo "::set-output name=help::$help"

env