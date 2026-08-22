# NGINX Ingress

Lets start a cluster that doesnt implement traefik by default, and bring our own
ingress controller instead.

## Variants

| Folder | App | Notes |
|--------|-----|-------|
| [01_podinfo](01_podinfo) | `stefanprodan/podinfo` | The walkthrough below. Cluster, deployment, service, ingress and the controller, step by step |
| [02_python_flask](02_python_flask) | `ghcr.io/dieguini/python-flask-sample` | Same idea with our own image, plus an explicit `IngressClass`. See [below](#python-flask-variant) |

## Usage

Two ways:

- **CLI**: Understand this with [CLI](#cli)
- **YAML**: Know that you know CLI, understand it with [YAML](#yaml)

### CLI

#### 1. Create cluster (!Important)

```sh
k3d cluster create mycluster --api-port 6445 -p "8081:80@loadbalancer" --servers 1 --agents 2 --k3s-arg "--disable=traefik@server:*" --k3s-arg "--tls-san=127.0.0.1@server:*" --k3s-arg "--disable=servicelb@server:*"
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
# Get Pods
kubectl get pods
# Port Forwarding
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

2. Install Nginx Controller (Helm way)

```sh
# Creating the namespace
kubectl create ns ingress-nginx
# Add latest repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# Installing the latests ingress
helm install -f 01_podinfo/nginx-controller/values.yaml ingress-nginx/ingress-nginx --generate-name -n ingress-nginx
```

- `-f`: Custom values (Check 01_podinfo/nginx-controller/values.yaml)
- `--generate-name`: Random name
- `-n`: Namespace were is deployed

<ins>Test It!</ins>

1. Forward

```sh
# Get Pods
kubectl get pods -n ingress-nginx
# Port forwarding (Service)
kubectl port-forward service/ingress-nginx-<RANDOM-CHARTS>-controller 80:80 -n ingress-nginx
```

2. Curl It!

Need to pass a Header

```sh
curl -H "Host: my.podinfo.local" 127.0.0.1:6445
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
k3d cluster create --config 01_podinfo/cluster/00_myk3dcluster.yaml
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
kubectl apply -f 01_podinfo/kubernetes/01_deployment.yaml
```

<ins>Test It!</ins>

```sh
kubectl port-forward pod/podinfo-<SOME_RANDOM_CHARS> 8888:9898
```

Come on access it: http://127.0.0.1:8888

2. Expose Pod (Service)

```sh
kubectl apply -f 01_podinfo/kubernetes/02_service.yaml
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
kubectl apply -f 01_podinfo/kubernetes/03_ingress.yaml
```
This will still not work because:

- `--class=nginx`: We didnt install a _Nginx Pod_

2. Install Nginx Controller (Helm way)

```sh
# Creating the namespace
kubectl create ns ingress-nginx
# Add latest repo
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# Installing the latests ingress
helm install -f 01_podinfo/nginx-controller/values.yaml ingress-nginx/ingress-nginx --generate-name -n ingress-nginx
```

- `-f`: Custom values (Check 01_podinfo/nginx-controller/values.yaml)
- `--generate-name`: Random name
- `-n`: Namespace were is deployed

<ins>Test It!</ins>

1. Forward

```sh
kubectl port-forward service/xxxxxx 80:80
```

2. Curl It!

Need to pass a Header

```sh
curl -H "Host: my.podinfo.local" 127.0.0.1:6445
```

**NOTE**: Json should appear

3. (Optional) Edit your hosts file

Add

```
127.0.0.1 my.podinfo.local
```

Come on access it: http://my.podinfo.local

## Python Flask variant

Same exercise with our own image, in [02_python_flask](02_python_flask). The difference
is that here the `IngressClass` is declared explicitly instead of relying on the
controller's default.

### 1. Create cluster

```sh
k3d cluster create --config 02_python_flask/config.yaml
```

### 2. Deploy

Everything at once (Deployment + Service + Ingress in a single file):

```sh
kubectl apply -f 02_python_flask/app.yaml
```

Or one resource at a time, which is the point of the exercise:

```sh
kubectl apply -f 02_python_flask/pod.yaml
kubectl apply -f 02_python_flask/service.yaml
kubectl apply -f 02_python_flask/ingress-class.yaml
kubectl apply -f 02_python_flask/ingress.yaml
```

**NOTE**: `ingress-class.yaml` still uses `networking.k8s.io/v1beta1`, removed in
Kubernetes 1.22. On a recent cluster bump it to `networking.k8s.io/v1`.

### 3. Install the controller

```sh
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm install main nginx-stable/nginx-ingress
```

<ins>Test It!</ins>

```sh
kubectl port-forward service/main-nginx-ingress-controller 8081:80
curl 127.0.0.1:8081
```
