#!/bin/bash

. scripts/preconfig.sh

echo "Should create new? [yn]"
read option
if [ $option = 'y' ];then
    kops create cluster --zones us-west-2a ${NAME}
fi

echo "Want to edit? [yn]"
read option
if [ $option = 'y' ];then
    kops edit cluster ${NAME}
fi

echo "Can I build it? [yn]"
read option
if [ $option = 'y' ];then
    kops update cluster ${NAME} --yes
fi

sleep 120
kubectl get nodes \
    && kops validate cluster \
    && kubectl -n kube-system get po
