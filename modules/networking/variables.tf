variable "vpc_cidr" {
  type = string
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway for private subnet"
  default     = false
}