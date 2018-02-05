#!/bin/bash -e

. scripts/preconfig.sh

echo "Creating S3 Bucket: ${KOPS_BUCKET_NAME}"
aws s3api create-bucket \
    --bucket ${KOPS_BUCKET_NAME} \
    --region us-east-1

aws s3api put-bucket-versioning \
    --bucket ${KOPS_BUCKET_NAME} \
    --versioning-configuration Status=Enabled
