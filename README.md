# Kubernetes

Hands-on Kubernetes examples, ordered as a learning path: first get a cluster, then
learn the objects, then the operational topics (health, ingress, autoscaling).

Every folder is self-contained and has its own README with the exact commands.

## Learning path

| # | Folder | What you learn |
|---|--------|----------------|
| 01 | [01_clusters](01_clusters) | How to get a cluster: k3d (local), Vagrant + VirtualBox (kubeadm from scratch), EKS via eksctl |
| 02 | [02_kubernetes_101](02_kubernetes_101) | Core objects: Pod → ReplicaSet → Deployment → rollout/rollback → Service → the voting app |
| 03 | [03_probes](03_probes) | `livenessProbe`, `readinessProbe` and both combined, with a Flask app |
| 04 | [04_ingress_nginx](04_ingress_nginx) | Replacing Traefik with the NGINX ingress controller (two variants) |
| 05 | [05_autoscaling](05_autoscaling) | Traffic-based autoscaling: Locust + Prometheus + KEDA |

## Clusters

| Folder | Environment | Use it for |
|--------|-------------|-----------|
| [01_clusters/01_k3d](01_clusters/01_k3d) | k3d (k3s in Docker) | Everything in `02_` to `05_`. Fastest way to get going |
| [01_clusters/02_vagrant_virtualbox](01_clusters/02_vagrant_virtualbox) | VMs + kubeadm | Understanding what a cluster is made of: containerd, cgroups, CNI, join tokens |
| [01_clusters/03_eks_eksctl](01_clusters/03_eks_eksctl) | AWS EKS | A managed cluster in the cloud |

## Requirements

Depending on the folder: `docker`, `k3d`, `kubectl`, `helm`, and for `01_clusters/02_*`
also `vagrant` + `virtualbox`, for `01_clusters/03_*` `eksctl` + AWS credentials.

A [devcontainer](.devcontainer/devcontainer.json) is included with most of the tooling
already installed. The [Makefile](Makefile) has a few helpers:

```sh
make config                    # git safe.directory
make bash                      # k / m aliases
make installeks                # install eksctl
make install-nginx-controller  # add the nginx helm repo
```

## Conventions

- Folders are numbered `NN_name` and meant to be followed in order.
- Manifests inside a folder are numbered in apply order (`01_deployment.yaml`, `02_service.yaml`, …).
- Names are `snake_case`; nothing in a path that a shell would need escaping for.
