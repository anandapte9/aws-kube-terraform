# aws-kube-terraform

# This project is to create a fully automated single master Kubernetes cluster. To be used only for testing or demo purposes.

Pre-requisite:
- Have an AWS account and access/secret keys against your account. You should have full access EC2 APIs on your account.
- Have terraform installed - follow the instructions here - https://www.terraform.io/intro/getting-started/install.html
- setup either the path environment variable for terraform otherwise copy the executable to c:\windows directory.

Nice to haves:
- git bash - always good to have git bash if you are on windows platform to run this project AS-IS.
- atom editor - if you want to see the code and have fun modifying it yourself Atom is my own preferred editor but ofcourse you are free to use anyone of your choice.

- Do a git clone of the project - git clone https://github.com/anandapte9/aws-kube-terraform.git
- Navigate to the root folder and open git bash there.
- run the script setup.sh to setup your environment variables.

       sh setup.sh

- Initialize Terraform to download all the required plug-ins.

       terraform init

- Get all the terraform modules.

       terraform get

- Plan the Kube deployment.

       terraform plan

- apply the terraform configuration to stand up the kubernetes cluster.

       terraform apply

- Type yes if you are happy with the configurations being applied.
- Once the terraform apply is completed, it will show the outputs.
- Navigate to modules/compute/keys from git bash prompt and login to bastion host from there.

       ssh -i kube.pem ec2-user@<BASTION-IP>

- Login to Kube master instance from bastion instance.

       ssh -i kube.pem ec2-user@<KUBE-MASTER-PRIVATE-IP>

- Run Kubernetes command to confirm a working cluster.

       kubectl get node -- this should show one master and defined number of nodes.

       kubectl get pods --all-namespaces -- this should show all the control plane pods running.

- Once verification is complete and you want to delete the Kubernetes environment. Simply destroy the configuration.

       Terraform destroy.
