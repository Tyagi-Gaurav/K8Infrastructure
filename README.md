* Where are the credentials for AWS?
- Offline ~/Keys -
    - In the standard location: `~/.aws/credentials`  
- Create a user in AWS
    - Get the keys and secret
    - Add a new profile in `~/.aws/credentials`

Building Custom Command Line
============================
```go build main.go```

    
Custom Commands
===============
Get nodes
```
export CONTROL_PLANE_NODE=`terraform output control_plane_instance_ec2_public_dns`
./main nodes
```

Get pods
```
export CONTROL_PLANE_NODE=`terraform output control_plane_instance_ec2_public_dns`
./main pods
``` 
    

Helpful Commands
================    
    
Check status of kubelet
- ```systemctl status kubelet```

Check version of kubernetes
- ```kubectl version -o json```

Apply pod Network on Control Plane
- ```kubectl apply -f [podnetwork].yaml```

Check Control plane and DNS information
- ```kubectl cluster-info```

Check certificate expiration
- ```sudo kubeadm certs check-expiration```

See configMap for various K8 components
- ```kubectl get configMap -n kube-system```

Here is one example how you may list all Kubernetes containers running in cri-o/containerd using crictl:
- ```'crictl --runtime-endpoint /var/run/crio/crio.sock ps -a | grep kube | grep -v pause```
Once you have found the failing container, you can inspect its logs with:
- ```crictl --runtime-endpoint /var/run/crio/crio.sock logs CONTAINERID```
    
- ~~Control plane should be on a different subnet than worker node.~~
- ~~On Control plane, export KUBECONFIG=/etc/kubernetes/admin.conf~~~~
- ~~Don't start adding nodes to network until Control plane node is ready.~~
- ~~Download kube/config from Control plane and save it in Home directory.~~
- ~~Allow public IP to be accessible over the internet~~.
- ~~The config that is downloaded from control plane does not have public IP. Instead it has private IP.~~ 
- Role of node added to control plane is <empty>
- Schedule pods on the node (Manually)
    - Schedule a single redis pod on node.
    - Deploy an application with 2 application pods on the server.
    
- Automate 
    ~~- Get token from Control plane to add nodes to the network.~~
    ~~- Get available nodes on the network~~
    - Get pods deployed on the network  
    - Given a pod.yml, deploy on network.   