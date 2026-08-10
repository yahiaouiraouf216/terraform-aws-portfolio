variable "aws_region" {
  description = "Aws region where the infrastrucure will be deployed"
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod"
  }
} 