# kind (Kubernetes IN Docker) demo

This repository contains everything used in the
[kind](https://kind.sigs.k8s.io/) live demonstration done at the [Paris
Container Day 2019](https://paris-container-day.fr/) on 4th June 2019 by
[@Horgix](https://github.com/horgix).

Baring some (minor) adaptations, it should be usable to reproduce the demo
yourself as long as you have some cloud provider at hand.

## Why no local?

This demonstration repository contains everything for the demo themselves,
including what's needed to spawn instances on AWS and Scaleway with **all the
requirements** to run the demo smoothly.

It is not done locally because:

- I want to be able to do the live demo even if my laptop burns during the
  week-end before the conference
- I had some trouble with my local kind setup since I'm using btrfs as my
  Docker storage driver and it's officially not supported by kind (and more
  broadly by any Docker-in-Docker setup involving kubelet from what I found)
- It's easier to start from scratch when exploring - just trash the VM and go
  on!

Keep in mind these are the **talk live demo** constraints. You probably
**want** to somehow use kind locally for **some** end-to-end tests when
developping on Kubernetes or related projects.

# What in there?

- Ansible + Packer - TODO
- Terraform - TODO

```
.
├── README.md               # This file
└── setup
    ├── base-image          # Packer + Ansible
    ├── setup-secrets.sh    # Wrapper to export my secrets to relevant env vars
    └── terraform           # Terraform to spawn the instances
```

# Base image - What you'll end-up with

All of these, ready to use, with tools in your `$PATH`, etc. :

- A working Docker setup
- The `kubectl` CLI
- The `kind` CLI
- A working Golang setup including:
    - `GOROOT` and `GOPATH` correctly set in bash
    - Binaries from `GOROOT` and `GOPATH` in your `PATH`
- Some Kubernetes Go sources required to run the conformance tests
    - `k8s.io/test-infra/kubetest`
    - `k8s.io/kubernetes/hack`
    - `k8s.io/sample-controller`

# Running conformance tests

You **have to** `export KUBECTL_PATH` or it will try to find its own compiled
binary even if you have `kubectl` in your `PATH`.

After wandering around a lot about how to run the conformance tests against
kind, here are some notes (draft status, to be refined?) :

- `kubetest` is the main command
- `kubetest --test` is what interested us. Other testing lifecycle steps are
  really well describe in TODO LINK
- `kubetest --test --provider=skeleton` is often used as example but...
- `kubetest --test --provider=local` is we want to use but... is not enough!
- You have to pair it with `--deployment` !
- `kubetest --test --provider=local --deployment=kind` will try to find a kind
  cluster. By default it will look for a `kind-kubetest` cluster. By default,
  if you didn't give any cluster name to `kind create cluster`, it created one
  named simply `kind`
- You can tell `kubetest` to use this existing cluster with `kubetest --test
  --provider=local --deployment=kind --kind-cluster-name=kind(or whatever else
  you named your kind cluster)`
- OR you can totally forget about kind and hit it straight from you host just
  like any other Kubernetes cluster with `--deployment=local` and appropriate
  env variables (I guess?)

./hack/ginkgo-e2e.sh
line 146

... because it is looking for the ginkgo binary and for the e2e.test binary

make WHAT=test/e2e/e2e.test

Well described in https://github.com/kubernetes/community/blob/master/contributors/devel/sig-architecture/conformance-tests.md#running-conformance-tests

# Demo - kind basics

- Create a cluster
- List containers
- Connect to cluster
- List pods
- TODO add nodes?

# Demo - Conformance tests demo

Compile requirements:

    make WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo cmd/kubectl"

**Run kubetest** with on **only one conformance test** (K8s labels) for demo
purpose so it's quick to run:

    kubetest --test --provider=local --deployment=local --test_args="--ginkgo.focus=\[sig-cli\].Kubectl.client.\[k8s.io\].Kubectl.label"

# Demo - Controller deployment (and test?)

TODO present the controller and what it's doing. Add it as subtree/submodule of
this repository?

Compile the `sample-controller`:

    CGO_ENABLED=0 GOOS=linux go build -o sample-controller ~/go/src/k8s.io/sample-controller/

Run the `sample-controller` against or kind cluster:

    ./sample-controller -kubeconfig=$KUBECONFIG

TODO: containerize this controller, `kind load` it into the cluster, then
deploy it with the appropriate manifest

    FROM alpine:3.8
    ADD sample-controller /sample-controller
    ENTRYPOINT ["/sample-controller"]

Create the CRD:

    cat ~/go/src/k8s.io/sample-controller/artifacts/examples/crd.yaml
    kubectl apply -f ~/go/src/k8s.io/sample-controller/artifacts/examples/crd.yaml

Create a custom resource:

    cat ~/go/src/k8s.io/sample-controller/artifacts/examples/example-foo.yaml
    kubectl apply -f ~/go/src/k8s.io/sample-controller/artifacts/examples/example-foo.yaml

Check that it created the deployment:

   kubectl get deployments 

TODO logs of the controller?

# Demo - Kube-bench

TODO

# Demo - CI

TODO
