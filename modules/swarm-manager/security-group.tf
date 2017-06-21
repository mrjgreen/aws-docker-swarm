resource "aws_security_group" "swarm" {
  name = "${var.name}"
  description = "Docker Swarm Security Group"

  vpc_id = "${var.vpc-id}"

  ingress {
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    self        = true
  }
  ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    self        = true
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self        = true
  }
  ingress {
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self        = true
  }
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags {
    Name = "${var.name}"
    Application = "${var.application}"
    Provision = "terraform"
    ProvisionerSrc = "${var.provisionersrc}"
  }
}
