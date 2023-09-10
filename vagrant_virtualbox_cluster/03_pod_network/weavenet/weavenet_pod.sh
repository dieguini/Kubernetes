#!/bin/bash
# Doc: https://www.weave.works/docs/net/latest/kubernetes/kube-addon/

set -ex
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
