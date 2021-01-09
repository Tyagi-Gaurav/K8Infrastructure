#!/bin/sh

# Install KubeAdM and Kubelet

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#Initialise Kubeadm
sudo kubeadm config images pull

#Pass parameters for kubeadm to connect to a container runtime (CRI-O)
#sudo kubeadm init


sudo systemctl daemon-reload
sudo systemctl restart kubelet