variable "cluster_cidrs" {}
variable "all_cidr_block" {}
variable "cluster_cidr_block_by_availability_zone" {}
variable "allowed_availability_zones" {}

variable "amis" {}
variable "key_name" {}
variable "slave_count" {}

output "cluster_vpc_id" {
  value = aws_vpc.cluster_id_vpc.id
}

//output "gen_subnet_ids" {
//  value = aws_subnet.short_id_subnet_public_subnet.*.id
//}
