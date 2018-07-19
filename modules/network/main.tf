# VPC Definition
resource "aws_vpc" "kube-vpc" {
  cidr_block              = "${var.cidr-block}"

  tags {
    Name                  = "${format("%s-%s", var.environment, "Kube VPC")}"
	  Environment           = "${var.environment}"
  }
}

# Subnets Definition
resource "aws_subnet" "public-subnet" {
  count                   = 3
  vpc_id                  = "${aws_vpc.kube-vpc.id}"
  cidr_block              = "${element(var.public-subnet-cidr-block, count.index)}"
  availability_zone       = "${element(var.availability-zones, count.index)}"
  map_public_ip_on_launch = "true"

  tags {
    Name                  = "${format("%s-%s %d", var.environment, "Public Subnet", count.index + 1 )}"
	  Environment           = "${var.environment}"
  }
}

resource "aws_subnet" "private-subnet" {
  count                   = 3
  vpc_id                  = "${aws_vpc.kube-vpc.id}"
  cidr_block              = "${element(var.private-subnet-cidr-block, count.index)}"
  availability_zone       = "${element(var.availability-zones, count.index)}"

  tags {
    Name                  = "${format("%s-%s %d", var.environment, "Private Subnet", count.index + 1 )}"
  	Environment           = "${var.environment}"
  }
}

# Gateways Definition
resource "aws_eip" "nat-eip" {
    vpc                   = true
}

resource "aws_internet_gateway" "internet-gateway" {
    vpc_id                = "${aws_vpc.kube-vpc.id}"
}

resource "aws_nat_gateway" "nat-gateway" {
  allocation_id           = "${aws_eip.nat-eip.id}"
  subnet_id               = "${aws_subnet.public-subnet.0.id}"

  depends_on = ["aws_internet_gateway.internet-gateway"]

  tags {
    Name                  = "${format("%s-%s", var.environment, "NAT Gateway")}"
	  Environment           = "${var.environment}"
  }
}

#Route table Definition
resource "aws_route_table" "public-route" {
  vpc_id                  = "${aws_vpc.kube-vpc.id}"
  route {
        cidr_block        = "0.0.0.0/0"
        gateway_id        = "${aws_internet_gateway.internet-gateway.id}"
    }

  tags {
    Name                  = "${format("%s-%s", var.environment, "Public Route Table")}"
	  Environment           = "${var.environment}"
  }
}

resource "aws_route_table" "private-route" {
  vpc_id                  = "${aws_vpc.kube-vpc.id}"
  route {
        cidr_block        = "0.0.0.0/0"
        gateway_id        = "${aws_nat_gateway.nat-gateway.id}"
    }

  tags {
    Name                  = "${format("%s-%s", var.environment, "Private Route Table")}"
	  Environment           = "${var.environment}"
  }
}

resource "aws_route_table_association" "public-route-association" {
  count                   = 3
	subnet_id               = "${element(aws_subnet.public-subnet.*.id, count.index)}"
  route_table_id          = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "private-route-association" {
	count                   = 3
  subnet_id               = "${element(aws_subnet.private-subnet.*.id, count.index)}"
  route_table_id          = "${aws_route_table.private-route.id}"
}

#Security Group Definitions
resource "aws_security_group" "bastion-sg" {
  description             = "${format("%s-%s",var.environment, "Bastion Security Group")}"
  ingress {
        from_port         = 22
        to_port           = 22
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
  }
  egress {
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        cidr_blocks       = ["0.0.0.0/0"]
  }
  vpc_id                  = "${aws_vpc.kube-vpc.id}"

  tags {
    Name                  = "${format("%s-%s", var.environment, "Bastion Security Group")}"
  	Environment           = "${var.environment}"
  }
}

resource "aws_security_group" "node-lb-sg" {
  description             = "${format("%s-%s",var.environment, "Node LB Security Group")}"
  ingress {
        from_port         = 443
        to_port           = 443
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
  }
  ingress {
        from_port         = 80
        to_port           = 80
        protocol          = "tcp"
        cidr_blocks       = ["0.0.0.0/0"]
  }
  egress {
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        cidr_blocks       = ["0.0.0.0/0"]
  }
  vpc_id                  = "${aws_vpc.kube-vpc.id}"

  tags {
    Name                  = "${format("%s-%s", var.environment, "Node LB Security Group")}"
	  Environment           = "${var.environment}"
  }
}

resource "aws_security_group" "kube-node-instance-sg" {
  description             = "${format("%s-%s",var.environment, "Node Instance Security Group")}"
  ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        security_groups  = ["${aws_security_group.bastion-sg.id}"]
  }
  ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        security_groups  = ["${aws_security_group.node-lb-sg.id}"]
  }
  ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        security_groups  = ["${aws_security_group.bastion-sg.id}"]
  }
  egress {
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        cidr_blocks       = ["0.0.0.0/0"]
  }
  vpc_id                 = "${aws_vpc.kube-vpc.id}"

  tags {
    Name                 = "${format("%s-%s", var.environment, "Node Server Security Group")}"
	  Environment          = "${var.environment}"
  }
}

resource "aws_security_group" "kube-master-instance-sg" {
  description             = "${format("%s-%s",var.environment, "Node Instance Security Group")}"
  ingress {
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        security_groups  = ["${aws_security_group.bastion-sg.id}"]
  }
  ingress {
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        security_groups  = ["${aws_security_group.node-lb-sg.id}"]
  }
  ingress {
        from_port        = 0
        to_port          = 65535
        protocol         = "tcp"
        security_groups  = ["${aws_security_group.kube-node-instance-sg.id}"]
  }
  egress {
        from_port         = 0
        to_port           = 0
        protocol          = "-1"
        cidr_blocks       = ["0.0.0.0/0"]
  }
  vpc_id                 = "${aws_vpc.kube-vpc.id}"

  tags {
    Name                 = "${format("%s-%s", var.environment, "Node Server Security Group")}"
	  Environment          = "${var.environment}"
  }
}
