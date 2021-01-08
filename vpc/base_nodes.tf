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
resource "aws_subnet" "slave_nodes_subnet_public_subnet" {
  //count = length(var.allowed_availability_zones)
  vpc_id = aws_vpc.cluster_id_vpc.id
  cidr_block = element(values(var.cluster_cidr_block_by_availability_zone), 0) //Single AZ for now.
  map_public_ip_on_launch = true
  depends_on = [aws_internet_gateway.cluster_id_gw]
  availability_zone = element(keys(var.cluster_cidr_block_by_availability_zone), 0) //Single AZ for now.
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
resource "aws_route_table_association" "cluster_routing_association" {
  count = length(var.allowed_availability_zones)
  route_table_id = aws_route_table.cluster_id_routing.id
  subnet_id = element(aws_subnet.slave_nodes_subnet_public_subnet.*.id, count.index)
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

/*
  Security Group for Gen Short Id app
*/
resource "aws_security_group" "slaves_sec_group" {
  name = "slaves-sec-group"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = var.all_cidr_block
  }

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = var.all_cidr_block
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.all_cidr_block
  }

  vpc_id = aws_vpc.cluster_id_vpc.id
}

resource "aws_instance" "node_instance" {
  count = var.slave_count
  ami = var.amis
  instance_type = "t2.large"
  associate_public_ip_address = true

  security_groups = [aws_security_group.slaves_sec_group.id]
  subnet_id = element(aws_subnet.slave_nodes_subnet_public_subnet.*.id, 0) //Single AZ for now.
  iam_instance_profile = aws_iam_instance_profile.node_instance_profile.name
  key_name = var.key_name

  tags = {
    Application = "K8 Slave Node"
    Environment = "Dev"
  }

//  provisioner "remote-exec" {
//    script = "${path.module}/setup_zookeeper.sh"
//    connection {
//      type = "ssh"
//      user = "ec2-user"
//      host = self.public_ip
//      private_key = file(var.private_key_file)
//    }
//  }
}

