/*
  Creates resources for Worker nodes.
  1. Security Groups.
  2. EC2 Instance
  3. Provisioning of Worker nodes.
*/
/*
  Security Group for Control plane group
*/
resource "aws_security_group" "control_plane_sec_group" {
  name = "control-plane-sec-group"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = var.all_cidr_block
  }

  ingress {#For All to access Kube-API Server
    from_port = 6443
    protocol = "tcp"
    to_port = 6443
    cidr_blocks = var.all_cidr_block
  }

  ingress {#etcd server client API
    from_port = 2379
    protocol = "tcp"
    to_port = 2380
    self = true #Only used by services within this group.
  }

  ingress {#kubelet API
    from_port = 10250
    protocol = "tcp"
    to_port = 10250
    self = true #Only used by services within this group.
  }

  ingress {#kube-Scheduler
    from_port = 10251
    protocol = "tcp"
    to_port = 10251
    self = true #Only used by services within this group.
  }

  ingress {#kube-Controller-Manager
    from_port = 10252
    protocol = "tcp"
    to_port = 10252
    self = true #Only used by services within this group.
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.all_cidr_block
  }

  vpc_id = aws_vpc.cluster_id_vpc.id
}

resource "aws_instance" "control_plane_instance" {
  count = var.control_plane_count
  ami = var.amis
  instance_type = "t2.large"
  associate_public_ip_address = true

  security_groups = [aws_security_group.control_plane_sec_group.id]
  subnet_id = element(aws_subnet.slave_nodes_subnet_public_subnet.*.id, 0) //Single AZ for now.
  iam_instance_profile = aws_iam_instance_profile.node_instance_profile.name
  key_name = var.key_name

  tags = {
    Application = "K8 Control Plane Node"
  }

  provisioner "remote-exec" {
    script = "${path.module}/base_nodes_setup.sh"
    connection {
      type = "ssh"
      user = "centos"
      host = self.public_ip
      private_key = file(var.private_key_file)
    }
  }
}

