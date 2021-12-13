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

Key tech stacks are:

### Application / Middleware layer

| Component                | Stack                                                  | Deployment                                                                                                         |
|--------------------------|--------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------|
| Front end                | [React](https://reactjs.org/)                          | -                                                                                                                  |
| Load balancer            | -                                                      | OpenShift resource                                                                                                 |
| Backend / Batch / Worker | [Go](https://go.dev/) / [Node.js](https://nodejs.org/) | k8s Deployment                                                                                                     |
| RDB                      | [Postgres](https://www.postgresql.org/)                | [Crunchy PostgreSQL Operator](https://catalog.redhat.com/software/operators/detail/5e9872b23f398525a0ceafc6)       |
| Document DB              | [MongoDB](https://www.mongodb.com/)                    | [MongoDB Enterprise Kubernetes](https://catalog.redhat.com/software/operators/detail/5e9872923f398525a0ceafba)     |
| Object Storage           | [MinIO](https://min.io/)                               | [MinIO Hybrid Cloud Object Storage](https://catalog.redhat.com/software/operators/detail/60945b58d3f6d18cdbac26fe) |
| Queueing                 | [Kafka](https://kafka.apache.org/)                     | [AMQ Streams](https://catalog.redhat.com/software/operators/detail/5ef20efd46bc301a95a1e9a4)                       |
| Workflow                 | [Airflow](https://airflow.apache.org/)                 | -                                                                                                                  |

### DevOps

| Component    | Stack                                                                                                                     | Deployment                                                                                                                      |
|--------------|---------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|
| Service mesh | [Istio](https://istio.io/)                                                                                                | [Red Hat OpenShift Service Mesh](https://catalog.redhat.com/software/operators/detail/5ec53e8c110f56bd24f2ddc4)                 |
| Tracing      | [Jaeger](https://www.jaegertracing.io/)                                                                                   | [Red Hat OpenShift distributed tracing platform](https://catalog.redhat.com/software/operators/detail/5ec54a5c78e79e6a879fa271) |
| Monitoring   | [Prometheus](https://prometheus.io/) / [Grafana](https://grafana.com/)                                                    | -                                                                                                                               |
| Logging      | [Elasticsearch](https://www.elastic.co/) / [Fluentd](https://www.fluentd.org/) / [Kibana](https://www.elastic.co/kibana/) | -                                                                                                                               |
| CI           | [Tekton](https://tekton.dev/)                                                                                             | [RedHat OpenShift Pipelines](https://catalog.redhat.com/software/operators/detail/5ec54a4628834587a6b85ca5)                     |
| CD           | [ArgoCD](https://argoproj.github.io/cd/)                                                                                  | [Red Hat OpenShift GitOps](https://catalog.redhat.com/software/operators/detail/5fb288c70a12d20cbecc6056)                       |


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
