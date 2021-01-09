#!/bin/sh

# Install KubeAdm and Control plane components.

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#Initialise Kubeadm
sudo kubeadm config images pull

#Pass parameters for kubeadm to connect to a container runtime (CRI-O)
sudo systemctl daemon-reload
sudo systemctl restart kubelet


#sudo kubeadm init --pod-network-cidr=$CIDR
