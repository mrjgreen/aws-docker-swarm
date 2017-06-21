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
  security-group-ids = ["${ var.security-group-ids }", "${ aws_security_group.swarm.id }"]
  subnet-ids = ["${ var.subnet-ids }"]
  vpc-id = "${ var.vpc-id }"

  role = "manager"
  discovery-bucket = "${module.discovery-bucket.bucket}"
}
