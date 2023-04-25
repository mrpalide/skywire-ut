#!/usr/bin/env bash

curl -LO https://storage.googleapis.com/kubernetes-release/release/"$(curl -sL https://storage.googleapis.com/kubernetes-release/release/stable.txt)"/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

mkdir "$HOME"/.kube
echo "$KUBE_CONFIG_TEST" | base64 -d >"$HOME"/.kube/config
kubectl version
