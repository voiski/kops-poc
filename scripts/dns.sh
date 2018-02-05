#!/bin/bash -e

. scripts/preconfig.sh

if ${KOPS_STEP_DNS_CONFIGURED:-false};then
    echo "DNS already created!
    Run with KOPS_STEP_DNS_CONFIGURED=false to force a new creation!"
else 
    echo "Private DNS? [yn]"
    read option
    if [ ${option} = 'y' ];then
        kops create cluster --dns private ${KOPS_TARGET_SUBDOMAIN}
    elif [ ${option} = 'n' ];then
        ID=$(uuidgen) && \
            aws route53 create-hosted-zone \
            --name ${KOPS_TARGET_SUBDOMAIN} \
            --caller-reference $ID \
            | jq .DelegationSet.NameServers
        echo "Config those ns into your domain! Waiting..."
        read option
    else
        echo "Please pay more attention, wrong option $option =("
        exit 1
    fi
    echo 'export KOPS_STEP_DNS_CONFIGURED=${KOPS_STEP_DNS_CONFIGURED:-true}'
fi

echo "Configured NS (It can fail due the DNS cache update)"
echo "> dig ns ${KOPS_TARGET_SUBDOMAIN}"
dig ns ${KOPS_TARGET_SUBDOMAIN} \
    | grep -A 5 ANSWER\ SECTION \
    | grep awsdns
echo "Is it right?[yn] We should have 4!"
read option

if [ ${option} = 'y' ];then
    echo "Nice /o/"
    exit 0
elif [ ${option} = 'n' ];then
    echo "Misconfigured dns =("
    exit 1
else
    echo "Please pay more attention, wrong option $option =("
    exit 1
fi