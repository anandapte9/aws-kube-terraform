locals {
  public-key-filename  = "${path.module}/${var.type}${var.public-key-extension}"
  private-key-filename = "${path.module}/${var.type}${var.private-key-extension}"
}

resource "tls_private_key" "tls-keys" {
  algorithm = "RSA"
}

resource "aws_key_pair" "generated" {
  depends_on = ["tls_private_key.tls-keys"]
  key_name   = "${format("%s-%s-%s", var.environment, var.type, "key")}"
  public_key = "${tls_private_key.tls-keys.public_key_openssh}"
}

resource "local_file" "public_key_openssh" {
  depends_on = ["tls_private_key.tls-keys"]
  content    = "${tls_private_key.tls-keys.public_key_openssh}"
  filename   = "${local.public-key-filename}"
}

resource "local_file" "private_key_pem" {
  depends_on = ["tls_private_key.tls-keys"]
  content    = "${tls_private_key.tls-keys.private_key_pem}"
  filename   = "${local.private-key-filename}"
}
