SHELL := /bin/bash

# Start
all: config bash installgitflow
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

.PHONY: installgitflow
installgitflow:
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

