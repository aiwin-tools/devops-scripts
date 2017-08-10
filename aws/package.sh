#!/usr/bin/env bash

# Zip up everything
if [ -z "$GITLAB_CI" ]; then
    echo "Retrieving hash of last commit ..."
    COMMIT_ID=$(git rev-parse HEAD)
else
    echo "Retrieving hash of last commit from GitLab env variables ..."
    COMMIT_ID=$CI_BUILD_REF
fi

TIMESTAMP=$(date +%s)
if [ -n "$PROVIDED_VERSION" ] ; then
    VERSION="$PROVIDED_VERSION"_"$COMMIT_ID"_"$TIMESTAMP"
else
    VERSION="$COMMIT_ID"_"$TIMESTAMP"
fi
FILENAME="$EB_APP_NAME"_"$VERSION".zip

echo "Creating ZIP $FILENAME ..."
git archive -o "/tmp/$FILENAME" HEAD
