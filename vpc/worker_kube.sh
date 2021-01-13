#!/bin/sh

# Install KubeAdM and Kubelet

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

#Initialise Kubeadm
sudo kubeadm config images pull

sudo mkdir -p /var/lib/kubelet
sudo touch /var/lib/kubelet/config.yaml
cat <<EOF | sudo tee /var/lib/kubelet/config.yaml
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
cgroupDriver: systemd
EOF

#sudo kubeadm init


sudo systemctl daemon-reload
sudo systemctl restart kubelet

#Check status of kubelet
#systemctl status kubelet

##
# Here is one example how you may list all Kubernetes containers running in cri-o/containerd using crictl:
#		- 'crictl --runtime-endpoint /var/run/crio/crio.sock ps -a | grep kube | grep -v pause'
#		Once you have found the failing container, you can inspect its logs with:
#		- 'crictl --runtime-endpoint /var/run/crio/crio.sock logs CONTAINERID'
#
