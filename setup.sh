#!/bin/sh
set -e

terraform init
terraform fmt
terraform validate

terraform apply -auto-approve

export CONTROL_PLANE_NODE=`terraform output control_plane_instance_ec2_public_dns`

echo "Copying Kube Config from remote to local."
scp -o StrictHostKeyChecking=no -i ~/short_id_key_pair_2.pem centos@$CONTROL_PLANE_NODE:~/.kube/config ~/.kube/config
JOIN_COMMAND=`ssh -o StrictHostKeyChecking=no -i ~/short_id_key_pair_2.pem centos@$CONTROL_PLANE_NODE kubeadm token create --print-join-command`

values=$(jq -r ".values.outputs.worker_instance_ec2_public_dns.value[]" <<< `terraform show -json`)

for worker_node in $values ; do
  echo "Adding $worker_node to Cluster"
  ssh -o StrictHostKeyChecking=no -i ~/short_id_key_pair_2.pem centos@$worker_node sudo $JOIN_COMMAND
done
