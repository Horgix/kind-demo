#! /bin/bash

source ./lib/functions.sh

cmd "Compile the sample-controller" 'CGO_ENABLED=0 GOOS=linux go build -o sample-controller ~/go/src/k8s.io/sample-controller/'

cmd "Tell kubetest what cluster we want to test" 'export KUBECONFIG="$(kind get kubeconfig-path --name=pcd-demo)"'
 KUBECONFIG=$(kind get kubeconfig-path --name=pcd-demo)

 comment "TODO - Containerize the controller and inject/load it onto our cluster"

cmd "Run the sample-controller against our kind cluster" './sample-controller -kubeconfig=$KUBECONFIG &'
export KUBECTL_PATH=`which kubectl`

cmd "Let's define a CRD" 'cat ~/go/src/k8s.io/sample-controller/artifacts/examples/crd.yaml'

cmd "... and create it on our cluster" 'kubectl apply -f ~/go/src/k8s.io/sample-controller/artifacts/examples/crd.yaml'

cmd "Now define a custom resource of this CRD type" 'cat ~/go/src/k8s.io/sample-controller/artifacts/examples/example-foo.yaml'

cmd "... and instanciate it" 'kubectl apply -f ~/go/src/k8s.io/sample-controller/artifacts/examples/example-foo.yaml'

cmd "Did it create anything?" 'kubectl get foos'

cmd "What did the controller do?" 'kubectl get pods'

comment "TODO - Create and run an e2e test on this behavior"
