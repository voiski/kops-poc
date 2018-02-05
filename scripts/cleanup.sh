#!/bin/bash -e

. scripts/preconfig.sh

echo "Done, want to delete? [yn]"
read option
if [ ${option} = 'y' ];then
    kops delete cluster ${NAME}

    echo "
    
    !WARNING! Are you sure? [yn]"
    read option
    [ ${option} = 'y' ] && \
        kops delete cluster ${NAME} --yes && \
        echo "To full cleanup:
        - dns: https://console.aws.amazon.com/route53/home#hosted-zones:
        - bucket: https://s3.console.aws.amazon.com/s3
        - user: https://console.aws.amazon.com/iam/home#/users
        - group: https://console.aws.amazon.com/iam/home#/groups
        "
fi