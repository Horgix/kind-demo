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

It is not done locally on my laptop because:

- I want to be able to do the live demo even if my laptop burns during the
  week-end before the conference
- I had some troubles with my local kind setup since I'm using btrfs as my
  Docker storage driver and it's a [known issue with
  kind](https://kind.sigs.k8s.io/docs/user/known-issues/#docker-on-btrfs) (and
  more broadly by any Docker-in-Docker setup involving kubelet from what I
  found - See [moby/moby#9939](https://github.com/moby/moby/issues/9939) and
  [kubernetes/kubernetes
  #38337](https://github.com/kubernetes/kubernetes/issues/38337))
- It's easier to start from scratch when exploring - just trash the VM and go
  on!

Keep in mind these are the **talk live demo** constraints. You probably
**want** to somehow use kind locally for **some** end-to-end tests when
developping on Kubernetes or related projects.

# What's in there?

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

# Demo #1 - kind basics

**See the [`demo-01.sh` script](demo/demo-01.sh) for what's being run for
real**

- Create a cluster
- List containers
- Connect to the cluster
- List pods
- Play around
- TODO add nodes?

# Demo - Conformance tests demo

**See the [`demo-02.sh` script](demo/demo-02.sh) for what's being run for
real**

Compile requirements:

    make WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo cmd/kubectl"

**Run kubetest** with on **only one conformance test** (K8s labels) for demo
purpose so it's quick to run:

    kubetest --test --provider=local --deployment=local --test_args="--ginkgo.focus=\[sig-cli\].Kubectl.client.\[k8s.io\].Kubectl.label"

Same thing but without direct kind integration:

    kubetest --test --provider=local --deployment=kind --test_args="--ginkgo.focus=\[sig-cli\].Kubectl.client.\[k8s.io\].Kubectl.label"

# Demo - Controller deployment (and test?)

**See the [`demo-03.sh` script](demo/demo-02.sh) for what's being run for
real**

We're deploying a
[sample-controller](https://github.com/kubernetes/sample-controller) on our
kind cluster (can also be found as a git submodule in the `demo/` directory of
this repo) and testing it from the outside.

Compile the `sample-controller`:

    CGO_ENABLED=0 GOOS=linux go build -o sample-controller ~/go/src/k8s.io/sample-controller/

Run the `sample-controller` against or kind cluster:

    ./sample-controller -kubeconfig=$KUBECONFIG

**TODO**:

- Containerize this controller
- `kind load` it into the cluster
- Deploy it with the appropriate manifest

    FROM alpine:3.8
    ADD sample-controller /sample-controller
    ENTRYPOINT ["/sample-controller"]

Create the CRD:

    cat ~/go/src/k8s.io/sample-controller/artifacts/examples/crd.yaml
    kubectl apply -f ~/go/src/k8s.io/sample-controller/artifacts/examples/crd.yaml

Create a custom resource:

    cat ~/go/src/k8s.io/sample-controller/artifacts/examples/example-foo.yaml
    kubectl apply -f ~/go/src/k8s.io/sample-controller/artifacts/examples/example-foo.yaml

check that it created the resource and that the controller did its job:

    kubectl get foos
    kubectl get deployments 

**TODO**:

- Make the controller log
- Add an end-to-end test asserting the behavior we discovered manually

# Demo - Kube-bench

I wish I had the time to demo
[kube-bench](https://github.com/aquasecurity/kube-bench) against a kind cluster
but the talk had a time slot of 20min only so... it will be for another time :)

For the record, kube-bench is [already being integrated with
kind](https://github.com/aquasecurity/kube-bench#testing-locally-with-kind) -
take a look at it!

# Demo - CI

WIP
