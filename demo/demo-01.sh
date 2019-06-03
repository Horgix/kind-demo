#! /bin/bash

source ./lib/functions.sh

cmd "How does kind work?" "kind --help"

cmd "Pop a Kubernetes cluster with kind" "kind create cluster"

cmd "Is it running?" "kind get clusters"

cmd "What is running?" "docker ps"

cmd "kind itself is statefless!" 'docker ps -f "label=io.k8s.sigs.kind.cluster"'

cmd "Get kubeconfig for our cluster" 'export KUBECONFIG="$(kind get kubeconfig-path)"'
export KUBECONFIG=$(kind get kubeconfig-path)

cmd "What is running inside the cluster?" "kubectl get pods --all-namespaces"

cmd "Delete the kind-create K8s cluster" "kind delete cluster"

comment "The END :)"
