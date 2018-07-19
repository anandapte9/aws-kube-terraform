resource "aws_instance" "kube-server" {
  count                   = "${var.kube-instance-count}"
  ami                     = "${var.kube-ami}"
  instance_type           = "${var.instance-type}"
  key_name                = "${var.kube-key-name}"
  subnet_id               = "${element(var.subnet-id, count.index)}"
  vpc_security_group_ids  = ["${var.kube-instance-security-group}"]

  tags {
		Name                  = "${format("%s %s %d", var.environment, var.instance-category, count.index + 1)}"
		Environment           = "${var.environment}"
  }
}
