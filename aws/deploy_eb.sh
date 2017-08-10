#!/usr/bin/env bash

if [ $# -ne 2 ] && [ $# -ne 3 ] ; then
    echo "Usage: deploy_eb EB_APP_NAME EB_ENV_NAME [S3_EB_BUCKET]"
    exit -1
elif [ $# -eq 3 ] ; then
    S3_EB_BUCKET=$3
fi

# Getting beanstalk configuration for current environment
echo "Getting AWS environment configuration for beanstalk ..."
# Getting beanstalk settings
EB_APP_NAME=$1
EB_ENV_NAME=$2

# Reproduce steps in package.sh
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/package.sh"
VERSION_LABEL="$EB_APP_NAME-$EB_ENV_NAME-$VERSION"

# Copy the zip to S3
echo "Uploading ZIP to S3 $S3_EB_BUCKET ..."
aws s3 cp "/tmp/$FILENAME" "s3://$S3_EB_BUCKET/$FILENAME"

# Create a new version in eb
echo "Creating ElasticBeanstalk Application Version ..."
aws elasticbeanstalk create-application-version \
  --application-name $EB_APP_NAME \
  --version-label $VERSION_LABEL \
  --description $VERSION_LABEL \
  --source-bundle S3Bucket="$S3_EB_BUCKET",S3Key="$FILENAME" --auto-create-application

# Update to that version
echo "Updating ElasticBeanstalk Environment ..."
aws elasticbeanstalk update-environment \
  --application-name $EB_APP_NAME \
  --environment-name $EB_ENV_NAME \
  --version-label $VERSION_LABEL

echo "Done! Deployed version $VERSION_LABEL to $EB_ENV_NAME"