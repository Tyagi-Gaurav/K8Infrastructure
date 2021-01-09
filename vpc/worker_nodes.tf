/*
  Creates resources for Worker nodes.
  1. Security Groups.
  2. EC2 Instance
  3. Provisioning of Worker nodes.
*/

/*
  Security Group for Worker nodes
*/
resource "aws_security_group" "worker_sec_group" {
  name = "slaves-sec-group"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = var.all_cidr_block
  }

  ingress {#For Kubelet-API Server
    from_port = 10250
    protocol = "tcp"
    to_port = 10250
    #Self and Control Plane access
    security_groups = [aws_security_group.control_plane_sec_group.id]
    self = true
  }

  ingress {#Node Port Services
    from_port = 30000
    protocol = "tcp"
    to_port = 32767
    cidr_blocks = var.all_cidr_block #All Access
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = var.all_cidr_block
  }

  vpc_id = aws_vpc.cluster_id_vpc.id
}

resource "aws_instance" "worker_instance" {
  count = var.slave_count
  ami = var.amis
  instance_type = "t2.large"
  associate_public_ip_address = true

  security_groups = [aws_security_group.worker_sec_group.id]
  subnet_id = element(aws_subnet.slave_nodes_subnet_public_subnet.*.id, 0) //Single AZ for now.
  iam_instance_profile = aws_iam_instance_profile.node_instance_profile.name
  key_name = var.key_name

  tags = {
    Application = "K8 Worker Node"
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

  provisioner "remote-exec" {
    script = "${path.module}/worker_kube.sh"
    connection {
      type = "ssh"
      user = "centos"
      host = self.public_ip
      private_key = file(var.private_key_file)
    }
  }
}

