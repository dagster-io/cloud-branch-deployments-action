#!/bin/sh -l

echo "Hello $1"
time=$(date)
echo "::set-output name=time::$time"

help=$(dagster-cloud --help)
echo "::set-output name=help::$help"
