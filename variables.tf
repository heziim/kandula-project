variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "kubernetes_version" {
  description = "kubernetes version"
  default = 1.18
}

variable "consul_version" {
  description = "consul version to install"
  default     = "1.8.5"
}
