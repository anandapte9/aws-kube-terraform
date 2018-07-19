variable ssh-user {}

variable "kube-instance-count" {}
variable "master-ip-address" { default = [] }
variable "node-ip-address" { default = [] }
variable "bastion-public-ip" {type = "list"}
