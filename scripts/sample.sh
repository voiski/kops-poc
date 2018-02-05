#!/bin/bash -e

. scripts/preconfig.sh

# Simple to keep the original yml file
export KOPS_SAMPLE_MYSQL_PWD=MYSQL_ROOT_PASSWORD

echo "Let's deploy a sample app with mysql and wordpress!
https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/
"

echo "Creating mysql secret"
kubectl create secret generic mysql-pass --from-literal=password=${KOPS_SAMPLE_MYSQL_PWD}
kubectl get secrets

echo "deplying mysql"
kubectl create -f resources/mysql-deployment.yaml
sleep 60
kubectl get pvc
ok=$(kubectl get pvc | grep -c mysql-pv-claim)
[ $ok -eq 0 ] && echo "Something wrong with the vpc" && exit $ok
kubectl get pods
ok=$(kubectl get pods | grep -c wordpress-mysql)
[ $ok -eq 0 ] && echo "Something wrong with the pod" && exit $ok

echo "deplying wordpress"
kubectl create -f resources/wordpress-deployment.yaml
sleep 60
kubectl get pvc
ok=$(kubectl get pvc | grep -c wp-pv-claim)
[ $ok -eq 0 ] && echo "Something wrong with the vpc" && exit $ok
kubectl get services wordpress
ok=$(kubectl get services wordpress | grep -c wordpress)
[ $ok -eq 0 ] && echo "Something wrong with the pod" && exit $ok

echo " 
    Please, access the k8 dashboard first to get the external wordpress endpoint:
    https://api.${NAME}/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/#!/service/default/wordpress?namespace=default

    Look for *External endpoints* and access it to make tests.
"

echo "Done, read to drop eveything? [yn]"
read option
if [${option} = 'y'];then
    kubectl delete secret mysql-pass
    kubectl delete deployment -l app=wordpress
    kubectl delete service -l app=wordpress
    kubectl delete pvc -l app=wordpress
fi