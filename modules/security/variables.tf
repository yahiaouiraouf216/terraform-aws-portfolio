variable "vpc_id" {
  type = string
}

variable "admin_cidr" {
  type = string
  description = "CIDR block allowed to access EC2 instances via SSH"
}