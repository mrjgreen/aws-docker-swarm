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
output "gateway-id" { value = "${ module.vpc.gateway-id }" }
output "id" { value = "${ module.vpc.id }" }
output "subnet-ids-public" { value = ["${ module.vpc.subnet-ids-public }"] }
output "route-table-id-main" { value = "${ module.vpc.route-table-id-main }" }
output "route-table-id-private" { value = "${ aws_route_table.private.id }" }
output "subnet-ids-private" { value = ["${ aws_subnet.private.*.id }"] }
