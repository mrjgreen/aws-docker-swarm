// Settings
variable "vpc-id" {}
variable "ami-id" {}
variable "key-name" {}
variable "instance-type" {}
variable "security-group-ids" {
  type = "list"
}
variable "subnet-ids" {
  type = "list"
}

// Instance Settings
variable "size" {
  default = 1
}
variable "volume_size" {
  default = 52
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
output "autoscaling-group-name" { value = "${ module.swarm.autoscaling-group-name }" }
output "discovery-bucket" { value = "${ module.discovery-bucket.bucket }" }
output "swarm-security-group-id" { value = "${ aws_security_group.swarm.id }" }
output "instance-role-id" { value = "${ module.swarm.instance-role-id }" }
