data "aws_ami" "amazon-linux" {
  most_recent = true
  filter {
    name      = "name"
    values    = ["amzn2-ami-hvm*-x86_64-gp2*"]
  }
  filter {
    name      = "virtualization-type"
    values    = ["hvm"]
  }
  filter {
    name      = "owner-alias"
    values    = ["amazon"]
  }
}
