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
  amis                                    = "ami-000e7ce4dd68e7a11" //Centos 8
  slave_count                             = 1
  control_plane_count                     = 1
  key_name                                = "short_id_key_pair_2"
  private_key_file                        = pathexpand("~/short_id_key_pair_2.pem")
}