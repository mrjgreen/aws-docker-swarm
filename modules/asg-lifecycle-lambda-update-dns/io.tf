// Settings
variable "zone_id" {}

variable "record" {
  type = "map"
}

variable "group_names" {
  type = "list"
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
