variable "cluster_cidrs" {}
variable "all_cidr_block" {}
variable "worker_cluster_cidr_block_by_availability_zone" {}
variable "control_plane_cluster_cidr_block_by_availability_zone" {}
variable "allowed_availability_zones" {}

variable "amis" {}
variable "key_name" {}
variable "slave_count" {}
variable "control_plane_count" {}
variable "private_key_file" {}

output "cluster_vpc_id" {
  value = aws_vpc.cluster_id_vpc.id
}

output "control_plane_instance_ec2_private_ip" {
  value = aws_instance.control_plane_instance.private_ip
}

output "control_plane_instance_ec2_public_dns" {
  value = aws_instance.control_plane_instance.public_dns
}

output "worker_instance_ec2_public_dns" {
  value = aws_instance.worker_instance.*.public_dns
}

//TODO Output EC2 instances IP/domain name.