############################
# Set these in terraform.tfvars
############################

variable "account_id" {
    description = "The allowed account id for which to apply these resources - prevents accidental overwrite"
}

variable "region" {
    description = "The region to deploy to the resources to"
}

variable "application" {
    description = "The name or name prefix of the application and associated resources"
}

variable "vpc_cidr_block" {
    description = "The VPC CIDR address range"
    #https://docs.docker.com/docker-for-aws/faqs/#recommended-vpc-and-subnet-setup
    default = "172.31.0.0/16"
}

variable "key_name" {
    description = "The name of the Key Pair that can be used to SSH to each instance in the cluster"
}

variable "route53_zone_id" {
    description = "The ID of the route 53 zone in which to create DNS entries"
}

variable "domain" {
    description = "The root domain name (including subdomain) to use for DNS records"
}

variable "provisionersrc" {
    description = "The url of this repository"
    default = "docker-swarm-aws"
}

variable "instance_type" {
    description = "The instance types launched into the cluster"
}

variable "swarm_manager_count" {
    description = "The number of instances to run as swarm managers"
}

variable "swarm_worker_count" {
    description = "The number of instances to run as swarm workers"
}

variable "volume_size" {
    description = "The disk size for each cluster instance"
}

variable "ssh_access" {
    description = "The source IP addresses allowed to SSH onto the cluster instances"
    type="list"
}
