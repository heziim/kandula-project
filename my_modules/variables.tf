variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "VPC name"
  type = string

}

variable "cidr_block" {
  description = "vpc's cidr block"
  type = string
}

variable "private_subnets" {
  description = "private subnet"
  type = list
}

variable "public_subnets" {
  description = "public subnet"
  type = list
}
