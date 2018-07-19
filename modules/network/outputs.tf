output "vpc_id" {
  value = "${aws_vpc.kube-vpc.id}"
}
output "public_subnet_id" {
  value = "${aws_subnet.public-subnet.*.id}"
}
output "private_subnet_id" {
  value = "${aws_subnet.private-subnet.*.id}"
}
output "bastion_security_group" {
  value = "${aws_security_group.bastion-sg.id}"
}
output "kube_master_instance_security_group" {
  value = "${aws_security_group.kube-master-instance-sg.id}"
}
output "kube_node_instance_security_group" {
  value = "${aws_security_group.kube-node-instance-sg.id}"
}
output "node_lb_security_group" {
  value = "${aws_security_group.node-lb-sg.id}"
}
