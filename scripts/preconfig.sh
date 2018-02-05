#!/bin/bash -e

if [ -f .env ];then
    . .env
else
    echo "With domain you want to use?"
    read KOPS_TARGET_DOMAIN
    export KOPS_TARGET_SUBDOMAIN=k8.${KOPS_TARGET_DOMAIN}

    export KOPS_BUCKET_NAME=${KOPS_TARGET_SUBDOMAIN//./-}-state-store

    export NAME=myfirstcluster.${KOPS_TARGET_SUBDOMAIN}
    export KOPS_STATE_STORE=s3://${KOPS_BUCKET_NAME}
    echo "
        export AWS_PROFILE=${AWS_PROFILE}

        export KOPS_TARGET_SUBDOMAIN=${KOPS_TARGET_SUBDOMAIN}
        export KOPS_BUCKET_NAME=${KOPS_BUCKET_NAME}
        export NAME=${NAME}
        export KOPS_STATE_STORE=${KOPS_STATE_STORE}
    " > .env
fi

if [ -z ${AWS_ACCESS_KEY_ID} ];then
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)
fi