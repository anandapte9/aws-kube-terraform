resource "aws_elb" "instance-lb" {
  name                      = "${format("%s-%s-%s", var.environment, var.type, "LB")}"

  listener {
    instance_port           = "${var.instance-port}"
    instance_protocol       = "${var.instance-protocol}"
    lb_port                 = "${var.lb-port}"
    lb_protocol             = "${var.lb-protocol}"
    ssl_certificate_id      = "${var.type == "app" ? var.ssl-certificate-id : ""}"
  }

  health_check {
    healthy_threshold       = 3
    unhealthy_threshold     = 5
    timeout                 = 5
    target                  = "${var.target-health-check}"
    interval                = 30
  }

  cross_zone_load_balancing = true
  idle_timeout              = 400
  subnets                   = ["${var.private-subnet-id}"]
  instances                 = ["${var.db-instances}"]
  security_groups           = ["${var.lb-security-group}"]

  tags {
    Name                    = "${format("%s %s %s", var.environment, var.type, "LB")}"
	  Environment             = "${var.environment}"
  }
}
