output "bastion-config-id" {
    value = "${null_resource.bastion-instance-init.*.id}"
}
