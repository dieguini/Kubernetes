# Pod Commands

First simple example to run a Pod

## Pre-requisits

<ins>Example</ins>

If running `k3d` or `k3s`

```shell
k3d cluster create -a 2 -s 1
```

## 1. First pod

Create first pod with an image, in this case an _nginx_ image

```shell
kubectl run nginx --image=nginx
```

## 2. Get pods

Basic info

```shell
kubectl get pods
```

## 3. Get pods

More info (Node info)

```shell
kubectl get pods -o wide
```

## 4. Describe Pod

```shell
kubectl describe pods nginx
```


