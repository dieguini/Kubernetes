# Probes

Playing with `livenessProbe` and `readinessProbe` on a Flask app, so you can see what
each one does when it fails. Every folder ships two manifests: the working one and one
that is broken on purpose.

| Folder | Probe | What breaking it does |
|--------|-------|-----------------------|
| [01_liveness](01_liveness) | `livenessProbe` | Kubelet keeps killing and restarting the container, `RESTARTS` goes up |
| [02_readiness](02_readiness) | `readinessProbe` | Pod stays `Running` but never `READY`, so the Service does not send traffic to it |
| [03_liveness_readiness](03_liveness_readiness) | both | Both effects at once |

The base app (no probes) lives in [00_base_app](00_base_app) — start there if this is
your first time.

## Usage

### 1. Cluster creation

Creating a cluster with Load

```sh
k3d cluster create cluster-pfs -p "8081:80@loadbalancer" --agents 2 --servers 1
```

<ins>Result</ins>

```sh
k3d cluster list
```

|NAME|          SERVERS|   AGENTS|   LOADBALANCER|
|-|-|-|-|
|cluster-pfs|   1/1|       2/2|      true|

### 2. Ingress and Service

Because this is a 'How to' learning proccess it is better to create one resource at a
time and test with deletions what happend

```sh
kubectl create -f ingress.yaml
kubectl create -f service.yaml
```

### 3. Pick a probe

Deploy the broken one first, look at what the cluster tells you, then deploy the good
one. Replace `<FOLDER>` with any of the folders in the table above.

```sh
# The one that fails on purpose
kubectl create -f <FOLDER>/pod_with_error.yaml
```

<ins>Result</ins>

**NOTE**: It may take time to implement

1. Describe pod

```sh
kubectl describe pod/python-flask-sample-<SOME_RANDOM_NUMBER>
```

2. Check the events, the important part is

| Type    | Reason    | Age                  | From    | Message                                                                                                    |
|---------|-----------|----------------------|---------|------------------------------------------------------------------------------------------------------------|
| Warning | Unhealthy | 14s (x29 over 4m24s) | kubelet | Readiness probe failed: Get "http://10.42.2.6:9999/": dial tcp 10.42.2.6:9999: connect: connection refused |

Analyze what you see! Check YAML's! 😁👍
The trick is always the same: the probe points at a port or a path that is not there.

3. Now the correct one

```sh
kubectl delete -f <FOLDER>/pod_with_error.yaml
kubectl create -f <FOLDER>/pod.yaml
```

<ins>Url</ins>

Enter to http://localhost:8081
Enjoy! 😁
