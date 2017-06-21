resource "aws_vpc" "main" {
  cidr_block = "${ var.cidr }"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags {
    Provisioner = "terraform"
    ProvisionerSrc = "${ var.provisionersrc }"
    Name = "${ var.name }"
    Application = "${ var.application }"
  }
}
