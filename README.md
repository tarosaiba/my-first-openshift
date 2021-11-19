# My first OpensShift

* I aim to create reference architecture for OpenShift.


# Repository structure
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

# Setup your CRC (CodeReady Container)

oc login -u developer https://api.crc.testing:6443
https://console-openshift-console.apps-crc.testing

*  Install Operator
```
oc apply -f projects.yaml
```

*  Install Operator
    - ※It looks this command didn't work. We should install with the console rather.
```
[ssaiba:~/github/my-first-openshift]$ oc apply -f sub.yaml
subscription.operators.coreos.com/openshift-pipelines-operator created
```

[Installing the Red Hat OpenShift Pipelines Operator in web console](https://docs.openshift.com/container-platform/4.7/cicd/pipelines/installing-pipelines.html)

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


