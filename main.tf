provider "aws" {
  profile = "default"
  region  = var.region
}

#Create VPC for nodes
module "vpc" {
  source                                                = "./vpc"
  cluster_cidrs                                         = var.cluster_cidrs
  all_cidr_block                                        = var.all_cidr_block
  worker_cluster_cidr_block_by_availability_zone        = var.worker_cluster_cidr_block_by_availability_zone
  control_plane_cluster_cidr_block_by_availability_zone = var.control_plane_cluster_cidr_block_by_availability_zone
  allowed_availability_zones                            = var.allowed_availability_zones
  amis                                                  = "ami-000e7ce4dd68e7a11" //Centos 8
  slave_count                                           = 1
  control_plane_count                                   = 1
  key_name                                              = "short_id_key_pair_2"
  private_key_file                                      = pathexpand("~/short_id_key_pair_2.pem")
}

output "cluster_vpc_id" {
  value = module.vpc.cluster_vpc_id
}

output "control_plane_instance_ec2_private_ip" {
  value = module.vpc.control_plane_instance_ec2_private_ip
}

output "control_plane_instance_ec2_public_dns" {
  value = module.vpc.control_plane_instance_ec2_public_dns
}

output "worker_instance_ec2_public_dns" {
  value = module.vpc.worker_instance_ec2_public_dns
}
