#!/bin/bash
# Doc: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd
echo "[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true" > /etc/containerd/config.toml

sudo systemctl restart containerd
