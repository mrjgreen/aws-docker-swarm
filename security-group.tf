// Dummy group to reference in the swarm module
// to allow swarm nodes in different groups to talk to each other
resource "aws_security_group" "app" {
  name = "${var.application}-app-sg"
  description = "Ports required by our application"

  vpc_id = "${module.vpc.id}"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["${var.ssh_access}"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    Name = "${var.application}-app-sg"
    Application = "${var.application}"
    Provision = "terraform"
    ProvisionerSrc = "${var.provisionersrc}"
  }
}
