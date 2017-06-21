variable "vpc_id" {
  description = "The VPC ID"
}

variable "route_table_ids" {
  description = "List of route table IDs to attach this endpoint to"
  type = "list"
}

variable "region" {
  description = "The bucket region"
}
