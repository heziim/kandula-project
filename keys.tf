resource "tls_private_key" "kandula_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kandula_key" {
  key_name   = "kandula_key"
  public_key = tls_private_key.kandula_key.public_key_openssh
}

resource "local_file" "kandula_key" {
  sensitive_content  = tls_private_key.kandula_key.private_key_pem
  filename           = "kandula_key.pem"
  file_permission    = "0400"
}
