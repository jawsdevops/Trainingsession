variable "aws_region" {
  default = "us-east-2"
}

variable "availability_zone" {
  description = "AZ zone"
  type        = string
  default     = "us-east-2"
}

variable "vpc_CIDR" {
  default = "10.0.0.0/16"
}

variable "subnet-1" {
  default = "10.0.1.0/24"
}

variable "subnet-2" {
  default = "10.0.2.0/24"
}

variable "subnet-3" {
  default = "10.0.3.0/24"
}

variable "subnet-4" {
  default = "10.0.4.0/24"
}

