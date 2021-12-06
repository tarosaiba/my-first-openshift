#!bin/bash
oc create -f projects.yaml
oc create -f operator.yaml
oc create -f default-scc.yaml

echo "please wait 60sec.."
sleep 60

oc create -f tekton
oc create -f argo

#  # TODO: run pipelines
#  echo "apiVersion: tekton.dev/v1beta1
#  kind: PipelineRun
#  metadata:
#    name: ci-pipeline-services-01
#    namespace: my-first-openshift-common
#    labels:
#      tekton.dev/pipeline: ci-pipeline-services
#  spec:
#    pipelineRef:
#      name: ci-pipeline-services
#    resources:
#      - name: appSource
#        resourceRef:
#          name: git-service-a
#      - name: appImage
#        resourceRef:
#          name: image-service-a
#    serviceAccountName: pipeline
#    timeout: 1h0m0s
#  " | oc create -f -

echo "Argo admin pass: "
kubectl -n openshift-gitops get secret openshift-gitops-cluster -o 'go-template={{index .data "admin.password"}}' | base64 -d
