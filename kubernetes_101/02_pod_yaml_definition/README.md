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

```shell
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod-definition.yaml
```

Can create a definition yaml file with 

- `--dry-run=client`: The Dry Run step fetches the Kubernetes manifests or Helm charts in a stage and performs a dry run (Simulation sin afectar al cluster)
- `-o`: Output _yaml_

Return the output to a _yml_ file

## Hands on Practice

Test some of the files:

- [nginx](nginx.yaml): Nginx image
- [redis](redis.yaml): Redis image