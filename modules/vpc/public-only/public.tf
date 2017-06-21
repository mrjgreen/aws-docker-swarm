resource "aws_internet_gateway" "main" {
  vpc_id = "${ aws_vpc.main.id }"

  tags {
    Provisioner = "terraform"
    ProvisionerSrc = "${ var.provisionersrc }"
    Name = "${ var.name }"
    Application = "${ var.application }"
  }
}

resource "aws_subnet" "public" {
  count = "${ length( var.azs ) }"

  availability_zone = "${ element( var.azs, count.index ) }"
  cidr_block = "${ cidrsubnet(var.cidr, 4, count.index) }"
  vpc_id = "${ aws_vpc.main.id }"

  map_public_ip_on_launch = "true"

  tags {
    Provisioner = "terraform"
    ProvisionerSrc = "${ var.provisionersrc }"
    Name = "${ var.name }"
    Application = "${ var.application }"
  }
}

resource "aws_route" "public" {
  route_table_id = "${ aws_vpc.main.main_route_table_id }"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${ aws_internet_gateway.main.id }"
}

resource "aws_route_table_association" "public" {
  count = "${ length(var.azs) }"

  route_table_id = "${ aws_vpc.main.main_route_table_id }"
  subnet_id = "${ element(aws_subnet.public.*.id, count.index) }"
}
