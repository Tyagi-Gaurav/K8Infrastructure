#!/bin/sh

# Install KubeAdM and Kubelet

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#Initialise Kubeadm
sudo kubeadm config images pull

sudo systemctl daemon-reload
sudo systemctl restart kubelet

# sudo kubeadm join #Pass a join configuration to this command


