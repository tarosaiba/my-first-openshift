#!bin/bash
oc create -f projects.yaml
oc create -f default-scc.yaml
oc create -f operator.yaml

echo "please wait 180sec.."
sleep 180

oc create -f tekton
oc create -f argo

# Run Pipelines
SUFFIX=`date +"%y%m%d-%H-%M-%S"`
## service-a
service="service-a"
echo "apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: ci-pipeline-${service}-${SUFFIX}
  namespace: my-first-openshift-common
  labels:
    tekton.dev/pipeline: ci-pipeline-services
spec:
  pipelineRef:
    name: ci-pipeline-services
  resources:
    - name: appSource
      resourceRef:
        name: git-${service}
    - name: appImage
      resourceRef:
        name: image-${service}
  serviceAccountName: pipeline
  timeout: 1h0m0s
" | oc create -f -

## service-b
service="service-b"
echo "apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: ci-pipeline-${service}-${SUFFIX}
  namespace: my-first-openshift-common
  labels:
    tekton.dev/pipeline: ci-pipeline-services
spec:
  pipelineRef:
    name: ci-pipeline-services
  resources:
    - name: appSource
      resourceRef:
        name: git-${service}
    - name: appImage
      resourceRef:
        name: image-${service}
  serviceAccountName: pipeline
  timeout: 1h0m0s
" | oc create -f -


echo "Argo admin pass: "
kubectl -n openshift-gitops get secret openshift-gitops-cluster -o 'go-template={{index .data "admin.password"}}' | base64 -d
