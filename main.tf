provider "aws" {
  profile = "default"
  region  = var.region
}

#Create VPC for nodes

module "vpc" {
  source                                  = "./vpc"
  cluster_cidrs                           = var.cluster_cidrs
  all_cidr_block                          = var.all_cidr_block
  cluster_cidr_block_by_availability_zone = var.cluster_cidr_block_by_availability_zone
  allowed_availability_zones              = var.allowed_availability_zones
  amis                                    = "ami-00c5940f2b52c5d98"
  slave_count                             = 1
  key_name                                = "short_id_key_pair_2"
}

#On each node, install container runtime
#