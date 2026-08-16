variable "subnet_id" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "private_subnet_id" {
  description = "Private subnet ID for the private EC2 instance"
  type        = string
}