#!/bin/bash
# Doc: https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd-systemd

# The TOML table names have to keep their inner quotes, because the key itself contains
# dots. Inside a plain double-quoted string bash strips them and containerd ends up
# reading a completely different key, so SystemdCgroup silently never applies.
# A quoted heredoc passes the text through untouched.
sudo tee /etc/containerd/config.toml > /dev/null <<'EOF'
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true
EOF

sudo systemctl restart containerd
