variable "channel" {
  default = "stable"
}

variable "virtualization_type" {
  default = "hvm"
}

data "aws_ami" "ami" {
  most_recent = true

  owners = ["595879546273"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "virtualization-type"
    values = ["${var.virtualization_type}"]
  }

  filter {
    name   = "name"
    values = ["CoreOS-${var.channel}-*"]
  }
}

output "image_id" {
  value = "${data.aws_ami.ami.image_id}"
}
