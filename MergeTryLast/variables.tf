variable "region" {
  description = "The AWS region to deploy the VPC"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "vpc01"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.215.51.0/25"
}

variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.215.51.0/26", "10.215.51.64/27", "10.215.51.96/27"]
}

variable "private_subnet_azs" {
  description = "A list of availability zones for the private subnets"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "environment" {
  description = "The environment name"
  type        = string
  default     = "sit"
}

variable "project" {
  description = "The Project name"
  type        = string
  default     = "mmd"
}

variable "reg" {
  description = "The Regon Short Form"
  type        = string
  default     = "ew1"
}
