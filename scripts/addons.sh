#!/bin/bash -e

. scripts/preconfig.sh

install_addon(){
    echo "Installing addon $1 version $2"
    kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/$1/v$2.yaml
}

install_addon kubernetes-dashboard 1.8.1
export KOPS_ADMIN_PWD=$(kops get secrets kube --type secret -oplaintext)
echo "You can see the dashboard now:
    https://api.${NAME}/ui
    User: admin
    Pwd: ${KOPS_ADMIN_PWD}"
install_addon monitoring-standalone 1.7.0

sleep 60

echo "Check if it is ok!"
kops validate cluster