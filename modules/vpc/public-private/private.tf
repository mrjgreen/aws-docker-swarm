module "vpc" {
  source = "../public-only"

  # variables
  azs = "${ var.azs }"
  cidr = "${ var.cidr }"
  application = "${ var.application }"
  name = "${ var.name }"
  provisionersrc = "${ var.provisionersrc }"
}

resource "aws_eip" "nat" { vpc = true }

resource "aws_nat_gateway" "nat" {
  depends_on = [
    "module.vpc",
  ]

  allocation_id = "${ aws_eip.nat.id }"
  subnet_id = "${ module.vpc.subnet-ids-public[0] }"
}

resource "aws_subnet" "private" {
  count = "${ length( var.azs ) }"

  availability_zone = "${ element( var.azs, count.index ) }"
  cidr_block = "${ cidrsubnet(var.cidr, 4, count.index + 4) }"
  vpc_id = "${ module.vpc.id }"

  map_public_ip_on_launch = "false"

  tags {
    Provisioner = "terraform"
    ProvisionerSrc = "${ var.provisionersrc }"
    Name = "${ var.name }"
    Application = "${ var.application }"
  }
}

resource "aws_route_table" "private" {
  vpc_id = "${ module.vpc.id }"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${ aws_nat_gateway.nat.id }"
  }

  tags {
    Provisioner = "terraform"
    ProvisionerSrc = "${ var.provisionersrc }"
    Name = "${ var.name }"
    Application = "${ var.application }"
  }
}

resource "aws_route_table_association" "private" {
  count = "${ length(var.azs) }"

  route_table_id = "${ aws_route_table.private.id }"
  subnet_id = "${ element(aws_subnet.private.*.id, count.index) }"
}
