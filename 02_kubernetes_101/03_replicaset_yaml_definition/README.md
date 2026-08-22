# Replication Controller/Replica Set YAML Definition

_Controllers_ are the brain of Kubernetes, they are the _process that monitor the kubernetes objects_

## Replication Controller

- Helps in running multiple instances of a pod in the cluster (High Availability)
- Also it keeps track on how many pods should our cluster have
	- _Want 3 Pods minimum always_ or _Want 1 Pods minimum always_ 

## Load Balancing & Scaling

If the number of users increase and the first Node is out of resources we could increase Nodes

## Replication Controller vs Replica Set

### Replication Controller

```yaml
apiVersion: v1
kind: ReplicationController
metadata:
  name: myapp-rc
spec:
  replicas: 3
  selector:
    app: myapp
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: frontend
    spec:
      containers:
        - name: nginx-container
          image: nginx
```

- **replicas**: Number of replicas
- **template**: Is from the _Pod_ only metadata and spec

```shell
kubectl get replicationcontrollers
```

### Replication Set

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: myapp-rs
  labels: 
    app: myapp
    type: front-end
spec:
  replicas: 3
  template:
    metadata:
      name: myapp-pod
      labels:
        app: myapp
        type: front-end
    spec:
      containers:
        - name: nginx-container
          image: nginx
  selector:
    matchLabels:
      app: myapp
      type: front-end
```

- **selector**: (Required) Main difference, what pods fault under it?

```shell
kubectl get replicasets
```

<ins>Question</ins>

Why select the pods if there are already on _template_ section?

<ins>Answer</ins>

Because ReplicaSet can handle any Pods in the cluster

## Labels and Selectors

_ReplicaSet_ could be used to monitor pods that are already created, you could select pods based on the labels of _Pods_

## Scale

2 ways

- **Update the definition file**: Just change the _Replicas_ option
- Use command

```shell
kubectl scale --replicas=6 -f rs-definition.yaml
# or
kubectl scale --replicas=6 -f replicaset myapp-rs
```

## Hands on Practice

Test some of the files:

- [Replication Controller](rc-definition.yaml)
- [Replica Set](rs-definition.yaml)