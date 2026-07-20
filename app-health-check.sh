#!/bin/bash

URL=$1

if [ -z "$URL" ]; then
    echo "Usage: ./app-health-check.sh <URL>"
    exit 1
fi

STATUS_CODE=$(curl -o /dev/null -s -w "%{http_code}" "$URL")

echo "Checking application: $URL"
echo "HTTP Status Code: $STATUS_CODE"

if [ "$STATUS_CODE" -eq 200 ]; then
    echo "Application Status: UP"
else
    echo "Application Status: DOWN"
fi