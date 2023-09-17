# K3D

Lets start a cluster that doesnt implement traefik by default

## Usage

Two ways:

- CLI: Understand this with [CLI](#cli)
- YAML: Know that you know CLI, understand it with [YAML](#yaml)

### CLI

#### 1. Create cluster (!Important)

```sh
k3d cluster create mycluster --api-port 127.0.0.1:6445 --servers 1 --agents 2 --k3s-arg "--disable=traefik@server:*" --k3s-arg "--tls-san=127.0.0.1@server:*" --k3s-arg "--disable=servicelb@server:*"
```

<ins>Understanding</ins>

Most important part is disabling:

- _Traefik Pod_, it creates an automatic ingress Pod (Default with k3d)
- Disabling the _Servicelb_ because we will implemented our own, args that does this

```shell
--k3s-arg "--disable=traefik@server:*" --k3s-arg "--tls-san=127.0.0.1@server:*
```

#### 2. Deploy de neccesary

1. Sample Deployment

This will create a _Pod_

```sh
kubectl create deployment podinfo --image=stefanprodan/podinfo --port=9898
```

<ins>Test It!</ins>

```sh
kubectl port-forward pod/podinfo-<SOME_RANDOM_CHARS> 8888:9898
```

Come on access it: http://127.0.0.1:8888

2. Expose Pod (Service)

This will create a _Service_

```sh
kubectl expose deployment podinfo --port=80 --target-port=9898 --type=LoadBalancer
```
<ins>Test It!</ins>

```sh
kubectl port-forward service/podinfo 7777:80
```

Come on access it: http://127.0.0.1:7777

#### 3. Ingress

Ingress is the viatal part of this explanation so

1. Ingress

```sh
kubectl create ingress podinfo --rule="my.podinfo.local/*=podinfo:80" --class=nginx
```
This will still not work because:

- `--class=nginx`: We didnt install a _Nginx Pod_

2. Install Nginx Controller

We are just adding the _repo_

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

3. Now create a _Pod_ via _helm_

```sh
helm install main nginx-stable/nginx-ingress
```

<ins>Test It!</ins>

1. Forward

```sh
kubectl port-forward service/main-nginx-ingress-controller 80:80
```

2. Curl It!

Need to pass a Header

```sh
curl -H "Host: my.podinfo.local" 127.0.0.1
```

**NOTE**: Json should appear

3. (Optional) Edit your hosts file

Add

```
127.0.0.1 my.podinfo.local
```

Come on access it: http://my.podinfo.local

### YAML

#### 1. Create cluster (!Important)

```sh
k3d cluster create --config myk3dcluster.yaml
```

<ins>Understanding</ins>

Most important part is disabling:

- _Traefik Pod_, it creates an automatic ingress Pod (Default with k3d)
- Disabling the _Servicelb_ because we will implemented our own, args that does this

```yaml
...
options:
  k3s: # options passed on to K3s itself
    extraArgs: # additional arguments passed to the `k3s server|agent` command; same as `--k3s-arg`
      - arg: --tls-san=127.0.0.1
        nodeFilters:
          - server:*
      - arg: --disable=traefik
        nodeFilters:
          - server:*
      - arg: --disable=servicelb
        nodeFilters:
          - server:*
...
```

#### 2. Deploy de neccesary

1. Sample Deployment

```sh
kubectl apply -f 01_deployment.yaml
```

<ins>Test It!</ins>

```sh
kubectl port-forward pod/podinfo-<SOME_RANDOM_CHARS> 8888:9898
```

Come on access it: http://127.0.0.1:8888

2. Expose Pod (Service)

```sh
kubectl apply -f 02_service.yaml
```

<ins>Test It!</ins>

```sh
kubectl port-forward service/podinfo 7777:80
```

Come on access it: http://127.0.0.1:7777

#### 3. Ingress

Ingress is the viatal part of this explanation so

1. Ingress

```sh
ubectl apply -f 03_ingress.yamlingress.yaml
```
This will still not work because:

- `--class=nginx`: We didnt install a _Nginx Pod_

2. Install Nginx Controller

We are just adding the _repo_

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

3. Now create a _Pod_ via _helm_

```sh
helm install main nginx-stable/nginx-ingress
```

<ins>Test It!</ins>

1. Forward

```sh
kubectl port-forward service/main-nginx-ingress-controller 80:80
```

2. Curl It!

Need to pass a Header

```sh
curl -H "Host: my.podinfo.local" 127.0.0.1
```

**NOTE**: Json should appear

3. (Optional) Edit your hosts file

Add

```
127.0.0.1 my.podinfo.local
```

Come on access it: http://my.podinfo.local