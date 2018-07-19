output "bastion_public_ip"   {
  value = "${aws_instance.bastion-server.*.public_ip}"
}
