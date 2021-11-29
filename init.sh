#!bin/bash
oc create -f operator.yaml
oc create -f projects.yaml

# Tekton
oc create -f tekton
oc adm policy add-scc-to-user privileged -nmy-first-openshift-common -z pipeline

# Argo
kubectl -n openshift-gitops get secret openshift-gitops-cluster -o 'go-template={{index .data "admin.password"}}' | base64 -d 
oc create -f argo/appprojects
oc create -f argo/applications
oc adm policy add-role-to-user admin system:serviceaccount:openshift-gitops:openshift-gitops-argocd-application-controller -n my-first-openshift-dev
