resource "null_resource" "kube-cluster-enable" {
  count          = "${var.kube-instance-count}"

  provisioner "local-exec" {
    command      = "sleep 500"
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
      "sudo chmod 600 /home/ec2-user/kube.pem",
      "command=`ssh -i /home/ec2-user/kube.pem -o 'StrictHostKeyChecking no' ec2-user@${var.master-ip-address[0]}  \"grep discovery-token-ca-cert-hash kubeadm-init.log\"`",
      "ssh -i /home/ec2-user/kube.pem -o 'StrictHostKeyChecking no' ec2-user@${element(var.node-ip-address, count.index)}  \"sudo $command\"",
    ]
   }
}
