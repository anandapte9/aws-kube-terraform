module "kube-network" {
	source                        = "./modules/network"
	environment                   = "${var.environment}"
	cidr-block                    = "${var.cidr-block}"
	public-subnet-cidr-block      = "${var.public-subnet-cidr-block}"
	private-subnet-cidr-block     = "${var.private-subnet-cidr-block}"
	availability-zones            = "${var.availability-zones}"
}

module "kube-keys" {
	source                       = "./modules/compute/keys"
	environment                  = "${var.environment}"
	type                         = "kube"
	public-key-extension         = ".pub"
	private-key-extension        = ".pem"
}

module "kube-aws-ami" {
	source                       = "./modules/compute/ami"
}

module "kube-bastion" {
	source                        = "./modules/compute/instances/bastion"
	environment                   = "${var.environment}"
	subnet-id                     = "${module.kube-network.public_subnet_id}"
	kube-instance-security-group  = "${module.kube-network.bastion_security_group}"
	kube-ami                      = "${module.kube-aws-ami.image_id}"
	kube-key-name                 = "${module.kube-keys.key-name}"
	instance-type                 = "${var.instance-type}"
	instance-category             = "bastion"
	instance-count                = 1
}

module "kube-masters" {
	source                        = "./modules/compute/instances/kube"
	environment                   = "${var.environment}"
	subnet-id                     = "${module.kube-network.private_subnet_id}"
	kube-instance-security-group  = "${module.kube-network.kube_master_instance_security_group}"
	kube-ami                      = "${module.kube-aws-ami.image_id}"
	kube-key-name                 = "${module.kube-keys.key-name}"
	instance-type                 = "${var.instance-type}"
	instance-category             = "master"
	kube-instance-count           = "${var.kube-master-count}"
}

module "kube-nodes" {
	source                        = "./modules/compute/instances/kube"
	environment                   = "${var.environment}"
	subnet-id                     = "${module.kube-network.private_subnet_id}"
	kube-instance-security-group  = "${module.kube-network.kube_node_instance_security_group}"
	kube-ami                      = "${module.kube-aws-ami.image_id}"
	kube-key-name                 = "${module.kube-keys.key-name}"
	instance-type                 = "${var.instance-type}"
	instance-category             = "node"
	kube-instance-count           = "${var.kube-node-count}"
}

module "bastion-config" {
	source                        = "./modules/configuration/bastion"
	instance-count                = 1
	ssh-user                      = "ec2-user"
	bastion-public-ip             = "${module.kube-bastion.bastion_public_ip}"
}

module "master-kube-config" {
	source                        = "./modules/configuration/kube"
	kube-instance-count           = "${var.kube-master-count}"
	ssh-user                      = "ec2-user"
	bastion-public-ip             = "${module.kube-bastion.bastion_public_ip}"
	kube-private-ip               = "${module.kube-masters.kube-instance-private-ip}"
	instance-category             = "master"
}

module "node-kube-config" {
	source                        = "./modules/configuration/kube"
	kube-instance-count           = "${var.kube-node-count}"
	ssh-user                      = "ec2-user"
	bastion-public-ip             = "${module.kube-bastion.bastion_public_ip}"
	kube-private-ip               = "${module.kube-nodes.kube-instance-private-ip}"
	instance-category             = "node"
}

module "kube-cluster-config" {
	source                        = "./modules/configuration/kube-cluster"
	kube-instance-count           = "${var.kube-node-count}"
	ssh-user                      = "ec2-user"
	bastion-public-ip             = "${module.kube-bastion.bastion_public_ip}"
	node-ip-address               = ["${module.kube-nodes.kube-instance-private-ip}"]
	master-ip-address             = ["${module.kube-masters.kube-instance-private-ip}"]
}

output "bastion-public-ip" {
	value = ["${module.kube-bastion.bastion_public_ip}"]
}

output "master-private-ip" {
	value = ["${module.kube-masters.kube-instance-private-ip}"]
}

output "node-private-ips" {
	value = ["${module.kube-nodes.kube-instance-private-ip}"]
}
