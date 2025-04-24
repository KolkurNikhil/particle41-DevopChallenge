variable "region" {
  description = "AWS region"
  type        = string
}


variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}
variable "project_name" {
  type        = string
  description = "Project name prefix for resources"
}
variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
}

variable "app_port" {
  description = "Application port number"
  type        = number

  validation {
    condition     = var.app_port > 0 && var.app_port <= 65535
    error_message = "Port must be between 1 and 65535."
  }
}
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  
  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "Must be a valid CIDR notation."
  }
}