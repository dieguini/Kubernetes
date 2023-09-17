# K3D Sample

Lets begin with simple commands

## Usage

### Command Example

- Create folder

```sh
mkdir -p /home/vscode/mycode
```

- Create cluster

```sh
k3d cluster create mycluster --api-port 127.0.0.1:6445 --servers 3 --agents 2 --volume '/home/vscode/mycode:/code@agent:0' --port '8080:80@loadbalancer'
```

### File example

Is the same command from above but in yaml, the yaml is [myk3dcluster.yaml](myk3dcluster.yaml)

```
k3d cluster create --config myk3dcluster.yaml
```

## Verify

- Cluster verification

```sh
k3d cluster list
```

- Node verification

```sh
k3d node list
```