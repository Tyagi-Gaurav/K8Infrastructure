#!/bin/sh
set -e

terraform init
terraform destroy -auto-approve
