# Deployments

## Why?

To better understand lets pretend the next case scenario

<ins>Case Scenario</ins>

1. You are going to deploy your application in production
2. You will deploy multiple pods of app (Obvious reasons)
3. New version to images will be update on your registry and will want to _upgrade_ versions
4. If any error you will want to _rollback_

<ins>Solution</ins>

Deployment of course 😁, mostly for the _upgrades_, _rollbacks_, _resume changes_, _rolling updates_, etc

## Definition

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp-pod
  template:
    metadata:
      labels:
        app: myapp-pod
    spec:
      containers:
      - name: myapp-container
        image: <Image>
```

### Tip: New great command

```shell
kubectl get all
```

## Commands

### Create Deployment

```shell
kubectl deployment <deployment_name> --image=<image_name> --repliacas=<number>
```

## Hands on Practice

Test some of the files:

- [Nginx Deployment](nginx-deployment-definition.yaml)