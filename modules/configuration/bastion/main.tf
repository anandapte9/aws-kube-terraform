resource "null_resource" "bastion-instance-init" {
  count          = "${var.instance-count}"

  provisioner "local-exec" {
    command      = "sleep 150"
  }

  connection {
     agent       = false
     timeout     = "10m"
     host        = "${element(var.bastion-public-ip, count.index)}"
     user        = "${var.ssh-user}"
     type        = "ssh"
     private_key = "${file("${path.root}/modules/compute/keys/kube.pem")}"
   }

   provisioner "file" {
    source = "${path.root}/modules/compute/keys/kube.pem"
    destination = "/home/ec2-user/kube.pem"
   }

   provisioner "file" {
    source = "${path.root}/modules/compute/upload-files/"
    destination = "/home/ec2-user"
   }

   provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
    ]
   }
}
