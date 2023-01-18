#!/usr/bin/env bash
# from https://github.com/stefanprodan/gitops-benchmark/blob/master/scripts/gen-hrs.sh

set -o errexit

COUNT=$1
REPO=https://github.com/stefanprodan/gitops-benchmark

rm -f 100-argocd-applications.yaml 100-argocd-helmreleases.yaml

for i in $(seq -w 1 $COUNT)
do

cat << EOF >> 100-argocd-applications.yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: gitops-benchmark-${i}
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
    repoURL: https://github.com/clementloiseletwescale/gitops-benchmark-${i}.git
    targetRevision: HEAD
    path: .
  destination:
    server: https://kubernetes.default.svc
    namespace: gitops-benchmark-${i}
  syncPolicy:
    automated:
      prune: true
      allowEmpty: true
      selfHeal: true
EOF

cat << EOF >> 100-argocd-helmreleases.yaml
---
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: podinfo-${i}
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: default
  source:
      chart: podinfo
      repoURL: https://stefanprodan.github.io/podinfo
      targetRevision: 6.3.0
      helm:
        releaseName: podinfo-${i}
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      allowEmpty: true
      selfHeal: true
EOF

done
