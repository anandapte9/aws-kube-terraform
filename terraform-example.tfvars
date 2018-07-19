#Initialization vriables
region = "REGION"
access-key = "ACCESS_KEY"
secret-key = "SECRET_KEY"
environment = "Kube"

# Networking variables
cidr-block = "10.0.0.0/16"
public-subnet-cidr-block = ["10.0.96.0/27","10.0.96.32/27", "10.0.96.64/27"]
private-subnet-cidr-block = ["10.0.0.0/19","10.0.32.0/19", "10.0.64.0/19"]
availability-zones = ["ap-southeast-2a","ap-southeast-2b", "ap-southeast-2c"]

#Instance variables
kube-master-count = 1
kube-node-count = NDOE_COUNT
instance-type = "t2.micro"
