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

variable "swarm-security-group-id" {}
variable "discovery-bucket" {}

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
output "instance-role-id" { value = "${ module.swarm.instance-role-id }" }
