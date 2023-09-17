# Kubernetes VMs

Here we are starting the configuration

## Pre-requisits

- Have [Vagrant Install](https://developer.hashicorp.com/vagrant/docs/installation)
- Have [Virtual Box](https://www.virtualbox.org/wiki/Downloads)

## Up

To start

```shell
vagrant up
```

<ins>To check</ins>

```
vagrant status
```

<ins>Expected (If default)</ins>

![vagrant_status](assets/vagrant_status.png)

## Connect

```shell
vagrant ssh <name_of_vm>
```

<ins>Example</ins>

```shell
vagrant ssh kubemaster-1
```

## Manual Provisioning (Optional)

In case you want to provision

```shell
vagrant provision --provision-with <name_of_script>
```

**NOTE:** Is calling the name of _vm.provision_ inside ("") in the vagrant file

<ins>Example</ins>

In _masterNodeConfig.vm.provision_ & _workerNodeConfig.vm.provision_ there is one "setup-hosts"

```shell
vagrant provision --provision-with setup-hosts
```

## Steps

Ok now we have some sections on [Vagrant File](Vagrantfile) with 

``!!!COMMENTED ON PURPOSE TO EXPLAIN FROM README.md!!!``

Uncomment the code parts and please check what every scripts is doing

### 1. Bridge traffic

```shell
vagrant provision --provision-with 01_bridge_traffic
```

### 2. Verify Netmodules

```shell
vagrant provision --provision-with 02_verify_netmodules
```

<ins>Expected</ins>

|Module|Size|Used|by|
|-|-|-|-|
|br_netfilter|(Some size)|0||
|bridge|(Some size)|1|br_netfilter|
|overlay|(Some size)|0||

### 3. Verify System Variables

```shell
vagrant provision --provision-with 03_verify_sysvar
```

<ins>Expected</ins>

```
net.bridge.bridge-nf-call-iptables = 1
kubemaster-1: net.bridge.bridge-nf-call-ip6tables = 1
kubemaster-1: net.ipv4.ip_forward = 1
```

### 4. ContainerD with apt

Because we use Ubuntu and we will be using apt for the installation

```shell
vagrant provision --provision-with 04_containerd
```

### 5. Cgroup driver (Systemd)

There are two cgroup drivers:

- cgroupfs
- systemd

You have to peak one depending on your system, kubelet should match

<ins>How to know what your system uses?</ins>

```shell
ps -p 1
```

<ins>Proceed</ins>

```shell
vagrant provision --provision-with 05_systemd_cgroupd
```

### 6. Installing kubeadm, kubelet and kubectl

- **kubeadm**: the command to bootstrap the cluster.
- **kubelet**: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
- **kubectl**: the command line util to talk to your cluster.

```shell
vagrant provision --provision-with 06_install_kkk
```

## Kubemaster

Specially read next [doc](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#initializing-your-control-plane-node)

### 1. Configure kubeadm

**EXECUTE ONLY IN MASTER NODE**

<ins>Explain</ins>

```shell
sudo kubeadm init --pod-network-cidr=<pods_cidr_block> --apiserver-advertise-address=<master_node_server>
```

- **pods_cidr_block**: IP Block for pods
- **master_node_server**: IP of master server

<ins>If default parameters</ins>

```shell
sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address=192.168.56.11
```

<ins>Result</ins>

Expected something similar

![kubeadm_init_expected.png](assets/kubeadm_init_expected.png)


### 2. Getting access kube config

```shell
vagrant provision --provision-with kube_master
```

### 3. Deploying a pod network

As specified in the image go to the link, there are a lot of network add-ons:

https://kubernetes.io/docs/concepts/cluster-administration/addons/

**Things to watch out for**

https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#-things-to-watch-out-for

- If you do set the --cluster-cidr option on kube-proxy, make sure it matches the IPALLOC_RANGE given to Weave Net (see below).

#### 3.1. Edit Weavenet

[Changing Configuration Options](https://www.weave.works/docs/net/latest/kubernetes/kube-addon/#-changing-configuration-options)

1. Get the deamon set

```shell
kubectl get ds -A
```
2. Provision Weavenet

```shell
vagrant provision --provision-with weavenet
```

3. Edit Weavenet

```shell
kubectl edit ds weave-net -n kube-system
```

<ins>Result</ins>

Expected something similar

![weavenet_result.png](assets/weavenet_result.png)


### 4. Joining worker nodes

From the result image we get we want join the worker nodes

<ins>Syntaxis</ins>
```shell
sudo kubeadn join <master_node_ip>:6443 --token <token> \
--discovery-token-ca-cert-hash sha256:<hash>
```

<ins>Example</ins>
```shell
sudo kubeadn join 192.168.56.11:6443 --token rwtzh4.5cpv3euigt1rgww6 \
--discovery-token-ca-cert-hash sha256:5qede91ceaU62cdea9758d8aeue12cd6ucc49Ubc27eedU7138ec597eUb9d6U46
```

### 5. Test!

With some random pod 😁

```shell
kubectl run nginx --image=nginx
```

## Reference

- [Install kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)
- [Install containerd](https://github.com/containerd/containerd/blob/main/docs/getting-started.md)
- [Configuring the systemd cgroup driver](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd)
