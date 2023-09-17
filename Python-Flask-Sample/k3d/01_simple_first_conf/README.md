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

- Deployment/Pod

```sh
kubectl create -f pod.yaml
```

<ins>Result</ins>

**NOTE**: It may take time to implement

Something similar to this

| NAME                                          | READY     | STATUS      | RESTARTS       | AGE     |     |
|-----------------------------------------------|-----------|-------------|----------------|---------|-----|
| pod/python-flask-sample-b778d8cfb-n4kqw       | 1/1       | Running     | 0              | 75s     |     |
| pod/python-flask-sample-b778d8cfb-75hgj       | 1/1       | Running     | 0              | 75s     |     |
| pod/python-flask-sample-b778d8cfb-jr7g7       | 1/1       | Running     | 0              | 75s     |     |


| NAME                                          | TYPE      | CLUSTER-IP  | EXTERNAL-IP    | PORT(S) | AGE |
|-----------------------------------------------|-----------|-------------|----------------|---------|-----|
| service/kubernetes                            | ClusterIP | 10.43.0.1   | 443/TCP        | 3m34s   |     |
| service/python-flask-sample                   | NodePort  | 10.43.84.20 | 5000:30800/TCP | 83s     |     |


| NAME                                          | READY     | UP-TO-DATE  | AVAILABLE      | AGE     |     |
|-----------------------------------------------|-----------|-------------|----------------|---------|-----|
| deployment.apps/python-flask-sample           | 3/3       | 3           | 3              | 75s     |     |
| NAME                                          | DESIRED   | CURRENT     | READY          | AGE     |     |
| replicaset.apps/python-flask-sample-b778d8cfb | 3         | 3           | 3              | 75s     |     |

<ins>Url</ins>

Enter to http://localhost:8081
Enjoy! 😁