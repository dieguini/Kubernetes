# Node Configuration

Same k3d cluster as [01_start](../01_start), but now we care about *which* node a Pod
lands on. The deployment here carries a `nodeSelector`, so it will only be scheduled on
nodes labelled `role=worker`.

## Usage

### 1. Create the cluster

```sh
k3d cluster create --config kubernetes/00_myk3dcluster.yaml
```

3 servers, 2 agents, API on `127.0.0.1:6445` and the loadbalancer on `8080:80`.

### 2. Label a node

k3d does not label the agents with `role=worker` by itself, so do it yourself,
otherwise the Pods below stay `Pending` forever.

```sh
kubectl get nodes
kubectl label node k3d-mycluster-agent-0 role=worker
```

### 3. Deploy

```sh
kubectl apply -f kubernetes/01_deployment.yaml
```

<ins>Test It!</ins>

All 5 replicas should sit on the labelled node:

```sh
kubectl get pods -o wide
```

Remove the label and delete a Pod to watch it get stuck in `Pending`:

```sh
kubectl label node k3d-mycluster-agent-0 role-
kubectl describe pod/podinfo-<SOME_RANDOM_CHARS>
```

The event you are looking for is `FailedScheduling: node(s) didn't match Pod's node
affinity/selector`.
