#!/bin/sh

CONTROL_PLANE_HOST=$1
TOKEN=$2
DISCOVERY_HASH=$3

kubeadm join $CONTROL_PLANE_HOST --token $TOKEN --discovery-token-ca-cert-hash $DISCOVERY_HASH
