#! /bin/bash

source ./lib/functions.sh

#cmd "Build test tooling" 'cd ~/go/src/k8s.io/kubernetes/ \
#	&& make WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo"'

cmd "Pop a new Kubernetes cluster with kind" "kind create cluster --name=pcd-demo"

cmd "Tell kubetest where to find kubectl" 'export KUBECTL_PATH=`which kubectl`'
export KUBECTL_PATH=`which kubectl`

cmd "Tell kubetest what cluster we want to test" 'export KUBECONFIG="$(kind get kubeconfig-path --name=pcd-demo)"'
export KUBECONFIG=$(kind get kubeconfig-path --name=pcd-demo)

cmd "Run a single conformance test with kubetest" 'cd ~/go/src/k8s.io/kubernetes/ \
	&& kubetest --test --provider=local --deployment=local \
	    --test_args="--ginkgo.focus=\[sig-cli\].Kubectl.client.\[k8s.io\].Kubectl.label"'

cmd "Run a single conformance test with kubetest... integrated with kind!" 'cd ~/go/src/k8s.io/kubernetes/ \
	&& kubetest --test --provider=local --deployment=kind \
            --kind-cluster-name=pcd-demo \
	    --test_args="--ginkgo.focus=\[sig-cli\].Kubectl.client.\[k8s.io\].Kubectl.label"'
