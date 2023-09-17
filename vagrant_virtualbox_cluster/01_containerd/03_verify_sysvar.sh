#!/bin/bash
# Doc: https://kubernetes.io/docs/setup/production-environment/container-runtimes/
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
