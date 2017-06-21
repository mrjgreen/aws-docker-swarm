// Settings
variable "group_names" {
  type = "list"
}
variable "lambda" {
  type = "map"
}

variable "env_vars" {
  type = "map"
}

variable "policy" {
  default = ""
}

variable "delay_termination" {
  default = 0
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
output "iam-role" { value = "${ aws_iam_role.notify.id }" }
