# kind (Kubernetes IN Docker) demo

This repository contains everything used in the
[kind](https://kind.sigs.k8s.io/) live demonstration done at the [Paris
Container Day 2019](https://paris-container-day.fr/) on 4th June 2019 by
[@Horgix](https://github.com/horgix).

Baring some (minor) adaptations, it should be usable to reproduce the demo
yourself as long as you have some cloud provider at hand.

## Why no local?

This demonstration repository

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

- Terraform
- Ansible + Packer 

```
.
├── README.md               # This file
└── setup
    ├── base-image          # Packer + Ansible
    ├── setup-secrets.sh    # Wrapper to export my secrets to relevant env vars
    └── terraform           # Terraform to spawn the instances
```

# What you'll end-up with

All of these, ready to use, with tools in your `$PATH`, etc. :

- A working Docker setup
- The `kubectl` CLI
- The `kind` CLI
- A working Golang setup including:
    - `GOROOT` and `GOPATH` correctly set in bash
    - Binaries from `GOROOT` and `GOPATH` in your `PATH`
- Some Kubernetes Go sources required to run the conformance tests
    - TODO


# Running conformance tests


Warning you have to export KUBECTL_PATH or it will try to find its own
compiled binary even if you have `kubectl` in your `PATH`
After wandering around a lot...


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

make WHAT="test/e2e/e2e.test vendor/github.com/onsi/ginkgo/ginkgo cmd/kubectl"

kubetest --test --provider=local --deployment=local --test_args="--ginkgo.focus=\[sig-cli\].Kubectl.client.\[k8s.io\].Kubectl.label"
