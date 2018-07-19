resource "null_resource" "kube-instance-init" {
  count          = "${var.kube-instance-count}"

  provisioner "local-exec" {
    command      = "sleep 300"
  }

  connection {
     agent       = false
     timeout     = "10m"
     host        = "${element(var.bastion-public-ip, count.index)}"
     user        = "${var.ssh-user}"
     type        = "ssh"
     private_key = "${file("${path.root}/modules/compute/keys/kube.pem")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/${var.instance-category}/kube-configure.sh",
      "sudo chmod 600 /home/ec2-user/kube.pem",
      "cd /home/ec2-user/${var.instance-category}",
      "scp -i /home/ec2-user/kube.pem -o 'StrictHostKeyChecking no' -p /home/ec2-user/${var.instance-category}/kube-configure.sh ec2-user@${element(var.kube-private-ip, count.index)}:/home/ec2-user",
      "ssh -i /home/ec2-user/kube.pem -o 'StrictHostKeyChecking no' ec2-user@${element(var.kube-private-ip, count.index)}  \"tr -d '\\15\\32' < kube-configure.sh > kube.sh\"",
      "ssh -i /home/ec2-user/kube.pem -o 'StrictHostKeyChecking no' ec2-user@${element(var.kube-private-ip, count.index)}  \"chmod +x kube.sh\"",
      "ssh -i /home/ec2-user/kube.pem -o 'StrictHostKeyChecking no' ec2-user@${element(var.kube-private-ip, count.index)}  \"./kube.sh\""
    ]
   }
}
