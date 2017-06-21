resource "aws_s3_bucket" "s3" {

  acl = "private"
  bucket = "${ var.bucket }"
  force_destroy = "${ var.force_destroy }"

  tags {
    Name = "${var.name}"
    Application = "${var.application}"
    Provision = "terraform"
    ProvisionerSrc = "${var.provisionersrc}"
  }
}
