#!bin/bash
oc create -f projects.yaml
oc create -f operator.yaml
oc create -f default-scc.yaml
oc create -f tekton
oc create -f argo
echo "Argo admin pass: "
kubectl -n openshift-gitops get secret openshift-gitops-cluster -o 'go-template={{index .data "admin.password"}}' | base64 -d
