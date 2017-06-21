###########################################
# The Auto Scaling Group & Launch Config
###########################################
module "swarm" {
  source = "../swarm"

  name = "${ var.name }"
  application = "${ var.application }"
  provisionersrc = "${ var.provisionersrc }"

  ami-id = "${ var.ami-id }"
  key-name = "${ var.key-name }"
  size = "${var.size}"
  volume_size = "${var.volume_size}"
  instance-type = "${ var.instance-type }"
  security-group-ids = ["${ var.security-group-ids }", "${ var.swarm-security-group-id }"]
  subnet-ids = ["${ var.subnet-ids }"]
  vpc-id = "${ var.vpc-id }"

  role = "worker"
  discovery-bucket = "${var.discovery-bucket}"
}
