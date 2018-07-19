output "kube-config-id" {
    value = "${null_resource.kube-instance-init.*.id}"
}
