variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
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

variable "alb_name" {
  description = "Name of the ALB"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "vpc_id" {
  description = "VPC ID where the ALB and target group are deployed"
  type        = string
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
}

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

# Port Mappings
variable "container_port" {
  description = "Port on which the container listens"
  type        = number
}

variable "host_port" {
  description = "Port on the host to bind to the container port"
  type        = number
}

# Environment Variables
variable "container_environment" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "execution_role_arn" {
  description = "ARN of the IAM role for ECS task execution"
  type        = string
}

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "container_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "knikhil999/simpletimeservice:latest"  # Set YOUR image as default
}
variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = can(regex("^dev|stage|prod$", var.environment))
    error_message = "Must be 'dev', 'stage', or 'prod'."
  }
}