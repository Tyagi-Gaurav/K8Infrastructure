variable "region" {
  default = "us-east-2"
}

variable "allowed_availability_zones" {
  default = [
    "us-east-2a",
    "us-east-2b",
    "us-east-2c"
  ]
}

variable "all_cidr_block" {
  default = [
  "0.0.0.0/0"]
}

variable "amis" {
  type = map(string)
  default = {
    "us-east-2" = "ami-0066309542889eda9"
  }
}

variable "cluster_cidr_block_by_availability_zone" {
  type = map(string)
  default = {
    us-east-2a = "172.31.1.0/24"
    us-east-2b = "172.31.2.0/24"
    us-east-2c = "172.31.3.0/24"
  }
}

variable "cluster_cidrs" {
  default = []
}