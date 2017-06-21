provider "aws" {
  allowed_account_ids = ["${var.account_id}"]
  max_retries = 5
  region = "${var.region}"
}

data "aws_availability_zones" "available" {}

module "ami" {
  source = "./modules/ami/amazon"
}

module "vpc" {
  source = "./modules/vpc/public-only"

  name = "${ var.application }-main-vpc"
  application = "${ var.application }"
  provisionersrc = "${ var.provisionersrc }"

  azs = "${ data.aws_availability_zones.available.names }"
  cidr = "${ var.vpc_cidr_block }"
}

module "s3-vpc-endpoint" {
  source = "./modules/vpc/s3-endpoint"
  vpc_id = "${module.vpc.id}"
  region = "${var.region}"
  route_table_ids = [ "${module.vpc.route-table-id-main}" ]
}

module "manager" {
  source = "./modules/swarm-manager"

  name = "${ var.application }-swarm-manager"
  application = "${ var.application }"
  provisionersrc = "${ var.provisionersrc }"

  ami-id = "${ module.ami.image_id }"
  key-name = "${ var.key_name }"
  size = "${var.swarm_manager_count}"
  volume_size = "${var.volume_size}"
  instance-type = "${ var.instance_type }"
  security-group-ids = ["${ aws_security_group.app.id }"]
  subnet-ids = ["${ module.vpc.subnet-ids-public }"]
  vpc-id = "${ module.vpc.id }"
}

module "worker" {
  source = "./modules/swarm-worker"

  name = "${ var.application }-swarm-worker"
  application = "${ var.application }"
  provisionersrc = "${ var.provisionersrc }"

  ami-id = "${ module.ami.image_id }"
  key-name = "${ var.key_name }"
  size = "${var.swarm_worker_count}"
  volume_size = "${var.volume_size}"
  instance-type = "${ var.instance_type }"
  security-group-ids = ["${ aws_security_group.app.id }"]
  subnet-ids = ["${ module.vpc.subnet-ids-public }"]
  vpc-id = "${ module.vpc.id }"

  swarm-security-group-id = "${ module.manager.swarm-security-group-id }"
  discovery-bucket = "${ module.manager.discovery-bucket }"
}

# Use autoscaling lifecycle rules to fire a lambda
# to update our DNS record
module "manager-auto-dns" {
  source = "./modules/asg-lifecycle-lambda-update-dns"

  name = "${ var.application }-swarm-manager-asg-dns"
  application = "${ var.application }"
  provisionersrc = "${ var.provisionersrc }"

  group_names = ["${ module.manager.autoscaling-group-name }"]
  zone_id = "${var.route53_zone_id}"
  record = {
    ttl = 300
    name = "${var.domain}"
    type = "A"
  }
}
