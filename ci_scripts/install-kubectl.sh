#!/usr/bin/env bash

curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

mkdir "$HOME"/.kube
echo "$KUBE_CONFIG" | base64 -d > "$HOME"/.kube/config
kubectl config use-context travis-context
kubectl version
