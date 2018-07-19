variable "instance-port" {}
variable "instance-protocol" {}
variable "lb-port" {}
variable "lb-protocol" {}
variable "ssl-certificate-id" {}
variable "target-health-check" {}
variable "lb-security-group" {}
variable "private-subnet-id" { type = "list"}
variable "environment" {}
variable "type" {}
variable "db-instances" { type = "list"}
