#!/bin/sh

echo "===== Begin Setup of Kubernetes Control Plane ======"
# Install KubeAdm and Control plane components.

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#Initialise Kubeadm
sudo kubeadm config images pull

#Pass parameters for kubeadm to connect to a container runtime (CRI-O)
sudo systemctl daemon-reload
sudo systemctl restart kubelet

echo "===== Begin Initialising of Kubernetes Cluster ======"
sudo kubeadm init --config /tmp/kubeadm_init.yml
sudo mkdir ~/.kube
sudo cp /etc/kubernetes/admin.conf ~/.kube/

sudo mv ~/.kube/admin.conf ~/.kube/config
sudo chmod 666 ~/.kube/config
sudo service kubelet restart

#Create Pod Network
#kubectl apply -f /tmp/podsubnet_init.yml