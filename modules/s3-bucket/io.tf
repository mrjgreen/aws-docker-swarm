// Settings
variable "bucket" {}
variable "force_destroy" {
  default = false
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
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
output "bucket" { value = "${ var.bucket }" }
output "arn" { value = "${ aws_s3_bucket.s3.arn }" }
