# My first OpensShift (OpenShift Reference Architecture)

The My first OpenShift is a OpenShift reference architecture. This provides a set of manifest files for deploying microservices to OpenShift cluster with devops tools.
You can deploy with only few steps with `init.sh` script.

## Requirements
* OpenShift >= 4.x
* oc client >= x.x

## Quick Start

* Clone or download this repository
* Go inside of directory, cd `my-first-openshift`
* Run this command `./init.sh`

## Overview

![Overview](./docs/images/overview.png)

## Resources

![Resources](./docs/images/resources.png)

## Repository structure
This reference architecture is composed of several GitHub repository.

```
# My First OpenShift
  -- Infrastructure
  * my-first-openshift ★This repository
    + Initial setup commands
    + OpenShift resource definitions (manifests files)
    + OpenShift Operator definitions (manifests files)
    + CI/CD setting (Tekton/ArgoCD)

  -- Applications (Sourcecode only)
  * XX-API
  * YY-API1
  * Worker
```

## Setup your CRC (CodeReady Container)

* Login
```
oc login -u developer https://api.crc.testing:6443
https://console-openshift-console.apps-crc.testing
```

* Create Project
```
oc apply -f projects.yaml
```

*  Install Operator (to all namespaces /Tekton&ArgoCD)
    - ※It looks this command didn't work. We should install with the console rather.
```
$ oc apply -f operator.yaml
subscription.operators.coreos.com/openshift-pipelines-operator created
```

[Installing the Red Hat OpenShift Pipelines Operator in web console](https://docs.openshift.com/container-platform/4.7/cicd/pipelines/installing-pipelines.html)

## 


# Reference
https://github.com/openshift/pipelines-tutorial#install-openshift-pipelines

# Memo
* I found SCC error https://githubmemory.com/repo/redhat-scholars/tekton-tutorial/issues/47
    - `oc adm policy add-scc-to-user privileged -ntektontutorial -z pipeline`
    - `oc adm policy add-scc-to-user privileged -nmy-first-openshift -z pipeline`

* test TEKTON task
`tkn task start -n my-first-openshift build-app --showlog`

# TODO
* TEKTON: Service accountの権限を絞る


# MEMO
* ArgoCDのログイン admin
```
kubectl -n openshift-gitops get secret openshift-gitops-cluster -o 'go-template={{index .data "admin.password"}}' | base64 -d
```


# Mongo Install
```
kubectl -n openshift-operators \
  create secret generic mongo-enterprise \
  --from-literal="publicKey=crigsydx" \
  --from-literal="privateKey=b75ac604-fbf2-49f7-aed6-1543adcef9a2"
```
