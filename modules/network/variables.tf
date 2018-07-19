# Environment Vairables
variable "environment" {}

# Networking variables
variable "cidr-block" {}
variable "public-subnet-cidr-block" { type = "list" }
variable "private-subnet-cidr-block" { type = "list" }
variable "availability-zones" { type = "list" }
