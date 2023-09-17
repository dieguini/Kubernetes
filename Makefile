SHELL := /bin/bash

# Start
all: config bash
.PHONY: all

# Local

.PHONY: config
config:
	@echo "=========== [CONFIG] ==========="
	git config --global --add safe.directory '*'

.PHONY: bash
bash:
	@echo "=========== [BASH PROFILE] ==========="
	echo "alias m=make" >> ~/.bashrc
	echo "alias k=kubectl" >> ~/.bashrc
	source ~/.bashrc

.PHONY: install-git-flow
install-git-flow:
	@echo "=========== [GIT FLOW INSTALL] ==========="
	sudo apt-get update
	sudo apt-get install git-flow

.DEFAULT_GOAL := all

.PHONY: installeks
installeks:
	@echo "=========== [INSTALL EKSCTL] ==========="
	curl --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
	sudo mv /tmp/eksctl /usr/local/bin
	eksctl version

.PHONY: install-nginx-controller
install-nginx-controller:
	@echo "=========== [INSTALL NGINX CONTROLLER] ==========="
	helm repo add nginx-stable https://helm.nginx.com/stable
	helm repo update
	@echo "Run if you wish: helm install <ANY NAME> nginx-stable/nginx-ingress"


