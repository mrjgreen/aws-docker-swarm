module "discovery-bucket" {
  source = "../s3-bucket"

  force_destroy = true

  bucket = "${ lower(var.name) }-swarm-discovery-bucket"
  name = "${ var.name }-swarm-discovery-bucket"
  application = "${ var.application }"
  provisionersrc = "${ var.provisionersrc }"
}
