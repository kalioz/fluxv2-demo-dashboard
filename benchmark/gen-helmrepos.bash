#!/usr/bin/env bash
# from https://github.com/stefanprodan/gitops-benchmark/blob/master/scripts/gen-hrs.sh

set -o errexit

: ${1?"Usage: $0 <NUMBER OF RELEASES>"}

COUNT=$1
REPO=https://github.com/stefanprodan/gitops-benchmark

rm -f 100-helmreleases.yaml

for i in $(seq -w 1 $COUNT)
do

cat << EOF >> 100-helmreleases.yaml
---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: podinfo-${i}
  namespace: default
spec:
  interval: 5m
  chart:
    spec:
      chart: podinfo
      version: '6.3.0'
      sourceRef:
        kind: HelmRepository
        name: podinfo
        namespace: default
EOF

done
