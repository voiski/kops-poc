# POC

KOPS validation

```bash
brew install kubectl kops
./run.sh
```

## Group/user

The kops user will require the following IAM permissions to function properly:

```
AmazonEC2FullAccess
AmazonRoute53FullAccess
AmazonS3FullAccess
IAMFullAccess
AmazonVPCFullAccess
```

> scripts/create_credentials.sh

## DNS

The kops host will need to be manually setup. We will use `k8.${domain}`.

> scripts/dns.sh

## bucket

> scripts/bucket.sh

## create first cluster

> scripts/cluster.sh

> scripts/addons.sh

## Sample application

> scripts/sample.sh

### Drop everything

> scripts/cleanup.sh


# Reference

* https://blog.docker.com/2018/01/docker-mac-kubernetes/
* https://www.youtube.com/watch?v=jWupQjdjLN0
* https://news.ycombinator.com/item?id=14715425
* https://opensource.com/business/14/9/open-source-datacenter-computing-apache-mesos
