output "kube-instance-private-ip" {
  value = "${aws_instance.kube-server.*.private_ip}"
}

output "instance_id"   {
  value = "${aws_instance.kube-server.*.id}"
}
