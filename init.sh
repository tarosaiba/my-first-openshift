#!bin/bash

oc create -f projects.yaml


oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth
oc create -f auth

oc create -f default-scc.yaml
oc create -f operator.yaml

echo "please wait 180sec.."
sleep 180

oc create -f tekton-v2
oc create -f argo
oc create -f logging

# Run Pipelines
SUFFIX=`date +"%y%m%d-%H-%M-%S"`
## service-a
service="service-a"
echo "apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: build-app-${service}-${SUFFIX}
  namespace: my-first-openshift-common
  labels:
    tekton.dev/pipeline: build-app
spec:
  pipelineRef:
    name: build-app
  params:
    - name: target-app
      value: ${service}
    - name: imageurl
      value: >-
        image-registry.openshift-image-registry.svc:5000/my-first-openshift-common
    - name: app-url
      value: 'https://github.com/tarosaiba/my-first-openshift-${service}.git'
    - name: app-revision
      value: master
  pipelineRef:
    name: build-app
  serviceAccountName: pipeline
  timeout: 1h0m0s
  workspaces:
    - name: app-code
      persistentVolumeClaim:
        claimName: workspace-small
    - emptyDir: {}
      name: vul-cache
  timeout: 1h0m0s
" | oc create -f -

## service-b
SUFFIX=`date +"%y%m%d-%H-%M-%S"`
## service-b
service="service-b"
echo "apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: build-app-${service}-${SUFFIX}
  namespace: my-first-openshift-common
  labels:
    tekton.dev/pipeline: build-app
spec:
  pipelineRef:
    name: build-app
  params:
    - name: target-app
      value: ${service}
    - name: imageurl
      value: >-
        image-registry.openshift-image-registry.svc:5000/my-first-openshift-common
    - name: app-url
      value: 'https://github.com/tarosaiba/my-first-openshift-${service}.git'
    - name: app-revision
      value: master
  pipelineRef:
    name: build-app
  serviceAccountName: pipeline
  timeout: 1h0m0s
  workspaces:
    - name: app-code
      persistentVolumeClaim:
        claimName: workspace-small
    - emptyDir: {}
      name: vul-cache
  timeout: 1h0m0s
" | oc create -f -

echo "Argo admin pass: "
kubectl -n openshift-gitops get secret openshift-gitops-cluster -o 'go-template={{index .data "admin.password"}}' | base64 -d
