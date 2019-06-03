#! /bin/bash

source functions.sh

cmd "How does kind work?" "kind --help"

cmd "Pop a Kubernetes cluster with kind" "kind create cluster"

cmd "Is it running?" "kind get clusters"

cmd "What is running?" "docker ps"

cmd "kind itself is statefless!" 'docker ps -f "label=io.k8s.sigs.kind.cluster"'

cmd "Delete the kind-create K8s cluster" "kind delete cluster --name=bla"

comment "The END :)"
