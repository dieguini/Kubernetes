# Pod YAML Definition

First definition of YAML in a Pod

## Structure

A Kubernetes definition file always contains 4 top level or root level fields 

```yaml
apiVersion:
kind:
metadata:
spec:
```

- **apiVersion**: Depending on what you want to create
- **kind**: Same _apiVersion_

| Kind       | Version |
| ---------- | ------- |
| Pod        | v1      |
| Service    | v1      |
| ReplicaSet | apps/v1 |
| Deployment | apps/v1 |
  
- **metadata**: Dictionary, there are some accepted values as (name and labels)
- **spec**: Depends on the object to create
	- **containers**: List/Array

## Create an object

```shell
kubectl create -f pod-definition.yaml
```

or

```shell
kubectl apply -f pod-definition.yaml
```

## Extra

### Dry-run

```shell
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod-definition.yaml
```

Can create a definition yaml file with

- `--dry-run=client`: The Dry Run step fetches the Kubernetes manifests or Helm charts in a stage and performs a dry run (Simulation sin afectar al cluster)
- `-o`: Output _yaml_

Return the output to a _yml_ file

### Recommended labels

Next info was get from [Kubernetes Docs - Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/)

| Key                            | Description                                                                                                             | Example        | Type   |
| ------------------------------ | ----------------------------------------------------------------------------------------------------------------------- | -------------- | ------ |
| `app.kubernetes.io/name`       | The name of the application                                                                                             | `mysql`        | string |
| `app.kubernetes.io/instance`   | A unique name identifying the instance of an application                                                                | `mysql-abcxzy` | string |
| `app.kubernetes.io/version`    | The current version of the application (e.g., a [SemVer 1.0](https://semver.org/spec/v1.0.0.html), revision hash, etc.) | `5.7.21`       | string |
| `app.kubernetes.io/component`  | The component within the architecture                                                                                   | `database`     | string |
| `app.kubernetes.io/part-of`    | The name of a higher level application this one is part of                                                              | `wordpress`    | string |
| `app.kubernetes.io/managed-by` | The tool being used to manage the operation of an application                                                           | `helm`         | string |

## Hands on Practice

Test some of the files:

- [nginx](nginx.yaml): Nginx image
- [redis](redis.yaml): Redis image