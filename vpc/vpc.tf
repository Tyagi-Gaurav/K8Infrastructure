/*
  Creates
  1. VPC
  2. Subnets
  3. Internet Gateway
  4. Route Table
  5. Route table association
  6. IAM Role
  7. IAM instance profile.
*/

/*
Each VPC belongs to a single Region and may contain multiple subnets;
*/
resource "aws_vpc" "cluster_id_vpc" {
  cidr_block = var.cluster_cidrs[0]
  enable_dns_hostnames = true

  tags = {
    name = "VPC for Cluster that holds all the nodes."
  }
}

resource "aws_internet_gateway" "cluster_id_gw" {
  vpc_id = aws_vpc.cluster_id_vpc.id

  tags = {
    Name = "cluster-id-gw"
  }
}

/*
Each subnet belongs to a single Availability Zone within that region.
And has a single route table.

Below creates a subnet for each availability zone.
*/
resource "aws_subnet" "worker_nodes_subnet_public_subnet" {
  //count = length(var.allowed_availability_zones)
  vpc_id = aws_vpc.cluster_id_vpc.id
  cidr_block = element(values(var.worker_cluster_cidr_block_by_availability_zone), 0) //Single AZ for now.
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.cluster_id_gw]
  availability_zone = element(keys(var.worker_cluster_cidr_block_by_availability_zone), 0) //Single AZ for now.
}

resource "aws_subnet" "control_plane_nodes_subnet_public_subnet" {
  //count = length(var.allowed_availability_zones)
  vpc_id = aws_vpc.cluster_id_vpc.id
  cidr_block = element(values(var.control_plane_cluster_cidr_block_by_availability_zone), 0) //Single AZ for now.
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.cluster_id_gw]
  availability_zone = element(keys(var.control_plane_cluster_cidr_block_by_availability_zone), 0) //Single AZ for now.
}

//Add all addresses access to internet gateway
resource "aws_route_table" "cluster_id_routing" {
  vpc_id = aws_vpc.cluster_id_vpc.id

  route {
    cidr_block = var.all_cidr_block[0]
    gateway_id = aws_internet_gateway.cluster_id_gw.id
  }
}

//Allow all public subnet instances access to internet
resource "aws_route_table_association" "control_plane_cluster_routing_association" {
  count = length(var.allowed_availability_zones)
  route_table_id = aws_route_table.cluster_id_routing.id
  subnet_id = element(aws_subnet.control_plane_nodes_subnet_public_subnet.*.id, count.index)
}

//Allow all public subnet instances access to internet
resource "aws_route_table_association" "worker_cluster_routing_association" {
  count = length(var.allowed_availability_zones)
  route_table_id = aws_route_table.cluster_id_routing.id
  subnet_id = element(aws_subnet.worker_nodes_subnet_public_subnet.*.id, count.index)
}

resource "aws_iam_role" "node_iam_role" {
  name = "node_iam_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "node_instance_profile"
  role = aws_iam_role.node_iam_role.name
}

