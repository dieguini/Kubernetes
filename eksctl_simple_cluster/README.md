# Simple eksctl cluster

This is a simple yaml configuration to create a cluster in AWS Infrastructure

## Pre requisits

- Install eksctl
- Have sufficient policy IAM Access permissions

## Usage

```sh
eksctl create cluster -f cluster.yaml
```