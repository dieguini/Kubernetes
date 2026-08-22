# Deployments – Update and Rollback

First we got to understand

## Rollout and Versioning

> Deployment -> Rollout -> Revision
> Upgrade Application -> Rollout -> Revision

1. When creating a deployment it triggers a _Rollout_
2. New _Rollout_ triggers a new _Revision_
3. If there is an _Application Upgrade_ a new _Rollout_ is created and a new _Revision_ too

**Note**: All to keep track on changes

## Rollout Command

### Status

To check how is it going with the "rollout", there it says how many replicas have been done so far

```shell
kubectl rollout status deployment/myapp-deployment
```

### History

Show revisions, like `git logs`

```shell
kubectl rollout history deployment/myapp-deployment
```

## Strategies

There are different type of strategies, this was get by another [site](https://thenewstack.io/deployment-strategies/)

- **Recreate**: Version A is terminated then version B is rolled out.
- **Ramped** (also known as **rolling-update** or incremental): Version B is slowly rolled out and replacing version A.
- **Blue/Green**: Version B is released alongside version A, then the traffic is switched to version B.
- **Canary**: Version B is released to a subset of users, then proceed to a full rollout.
- **A/B testing**: Version B is released to a subset of users under specific condition.
- **Shadow**: Version B receives real-world traffic alongside version A and doesn’t impact the response.

<ins>Course will check first two</ins>

### Recreate

The recreate strategy is a _dummy_ deployment which consists of shutting down version A then deploying version B after version A is turned off. This technique ==implies downtime== of the service that depends on both shutdown and boot duration of the application.

**Key**: Destroy all at once

### Ramped/RollingUpdate

The ramped deployment strategy consists of _slowly rolling_ out a version of an application by _replacing instances one after the other_ ==until all the instances are rolled out==. It usually follows the following process: with a pool of version A behind a load balancer, one instance of version B is deployed.

**Key**: One by one

## Updates

_"Update"_ word it is used when there are changes in:

- Application version
- Labels
- Number of replicas

<ins>How?</ins>

We could update the next way

- Change _deployment definition file_
- Commands

### Example Command Change

For the example check next case scenario

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: update-example-deployment
  labels:
    app: update-nginx
    type: front-end
spec:
  replicas: 3
  selector:
    matchLabels:
      app: update-nginx
      type: front-end
  template:
    metadata:
      name: update-example-pod
      labels:
        app: update-nginx
        type: front-end
    spec:
      containers:
        - name: update-example-container
          image: nginx:1.7.1
```

Want to change image version? Ok no problem 😁

```shell
kubectl set image deployment/update-example-deployment update-example-container=nginx:1.9.1
```

**Cons**: File doesn't have the change

## Upgrades

What happens under the hood?

- Creates a new _ReplicaSet_
- Starts creating _Pods_ and deleting old ones

## Rollback

```shell
kubectl rollout undo deployment/update-example-deployment
```

## Commands

### Create Deployment

```shell
kubectl create -f <deploment_file>
```

### Get Deployment

```shell
kubectl get <deployment_name>
```

### Update

```shell
kubectl apply -f <deploment_file>
```

```shell
kubectl edit <deployment_name> 
```

```shell
kubectl set image <deployment_name> <container>=<image>:<version> 
```

- `--record`: If record is set, Change Cause will show the command that changes the revision

### Status

```shell
kubectl rollout status <deployment_name>
```

```shell
kubectl rollout history <deployment_name>
```

### Rollback

```shell
kubectl rollout undo <deployment_name>
```

## Hands on Practice

Test file:

- [Nginx Update Deployment](update-example.yaml)