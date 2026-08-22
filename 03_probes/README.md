# Python Flask Sample

First yaml and cluster configurations and creations

# Usage

## Cluster creation

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

## YAML order creation

Because this is a 'How to' learning proccess it is better to create one resource at a time and test with deletions what happend

<ins>Order of creation</ins>

- Ingress

```sh
kubectl create -f ingress.yaml
```

- Service

```sh
kubectl create -f service.yaml
```

### Probes

#### readinessProbe

##### Error

Know we will start playing with probes on de pod deployments

- Test the pod with error with the [pod_with_error.yaml](probes/readinessProbe/pod_with_error.yaml)

```sh
kubectl create -f probes/readinessProbe/pod_with_error.yaml
```

<ins>Result</ins>

**NOTE**: It may take time to implement

1. Describe pod

```sh
kubectl describe pod/python-flask-sample-<SOME_RANDOM_NUMBER>
```

2. Check the events, the important part is

| Events: |           |                      |                   |                                                                                                                          |   |
|---------|-----------|----------------------|-------------------|--------------------------------------------------------------------------------------------------------------------------|---|
| Type    | Reason    | Age                  | From              | Message                                                                                                                  |   |
| ----    | ------    | ----                 | ----              | -------                                                                                                                  |   |
| Warning | Unhealthy | 14s (x29 over 4m24s) | kubelet           | Readiness probe failed: Get "http://10.42.2.6:9999/": dial tcp 10.42.2.6:9999: connect: connection refused               |   |
|         |           |                      |                   |                                                                                                                          |   |

Analyze what you see! Check YAML's! 😁👍
Test all probes

##### Correct one

```sh
kubectl create -f probes/readinessProbe/pod_with_error.yaml
```


<ins>Url</ins>

Enter to http://localhost:8081
Enjoy! 😁