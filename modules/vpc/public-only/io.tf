// Settings
variable "azs" {
  description = "List of availability zones"
  type = "list"
}

variable "cidr" {
  description = "CIDR subnet range"
}

// Tags
variable "name" {
  description = "Name tag"
}

variable "application" {
  description = "Application tag"
}

variable "provisionersrc" {
  description = "Tag linking to the repository"
}

// Outputs
output "gateway-id" { value = "${ aws_internet_gateway.main.id }" }
output "id" { value = "${ aws_vpc.main.id }" }
output "subnet-ids-public" { value = ["${ aws_subnet.public.*.id }"] }
output "route-table-id-main" { value = "${ aws_vpc.main.main_route_table_id }" }
