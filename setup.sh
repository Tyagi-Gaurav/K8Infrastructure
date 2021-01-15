#!/bin/sh
set -e

terraform init
terraform fmt
terraform validate

terraform apply -auto-approve

CONTROL_PLANE_NODE=`terraform output control_plane_instance_ec2_public_dns`

echo "Copying Kube Config from remote to local."
scp -o StrictHostKeyChecking=no -i ~/short_id_key_pair_2.pem centos@$CONTROL_PLANE_NODE:~/.kube/config ~/.kube/config