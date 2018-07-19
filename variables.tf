variable "region" {}
# Key variables

variable "access-key" {}
variable "secret-key" {}
variable "environment" {}

# Networking variables

variable "cidr-block" { }
variable "public-subnet-cidr-block" { type = "list" }
variable "private-subnet-cidr-block" { type = "list" }
variable "availability-zones" { type = "list" }

# Instance variables
variable "kube-master-count" {}
variable "kube-node-count" {}
variable "instance-type" {}
