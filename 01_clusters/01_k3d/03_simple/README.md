# K3d Simple

This is a simple and basic project to implement a cluster using k3d

## Usage

### Create Cluster

Simple cluster creation using [k3d.yaml](k3d.yaml) file

```sh
k3d cluster create --config .\k3d.yaml
```

### Deploy

Easily deploy the configuration of a _Python Flask_ example on my DockerHub

```sh
kubectl apply -f deploy/
```

[deploy/](deploy) holds the Deployment, the Service and the Ingress. The cluster maps
`80:80` on the loadbalancer, so open http://localhost