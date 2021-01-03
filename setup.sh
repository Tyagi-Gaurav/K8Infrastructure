#!/bin/sh
set -e

terraform init
terraform fmt
terraform validate

terraform apply -auto-approve
