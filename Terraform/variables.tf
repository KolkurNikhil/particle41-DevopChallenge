# -----------------------
# Global/Project Settings
# -----------------------
variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}
variable "service_name" {
  description = "Name of the ECS/ECR service"
  type        = string
  default     = "simpletimeservice"
}


# ----------------------
# Networking (VPC/Subnet)
# ----------------------
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be deployed"
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

variable "subnet_ids" {
  description = "List of subnet IDs to deploy the ALB"
  type        = list(string)
}

# ----------------------
# ALB & Target Group
# ----------------------
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for ALB"
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

variable "listener_port" {
  description = "Port for the ALB listener"
  type        = number
}

variable "health_check_path" {
  description = "Health check path for the ALB"
  type        = string
}

# -------------------
# ECS & Containers
# -------------------
variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
}

variable "host_port" {
  description = "Port on the host to bind to the container port"
  type        = number
}

variable "container_environment" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "container_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "knikhil999/simpletimeservice:latest"
}

# ------------------
# IAM / Role Settings
# ------------------


variable "execution_role_name" {
  description = "Name of the ECS task execution role"
  type        = string
}

variable "aws_role_arn" {
  description = "ARN of IAM role to assume"
  type        = string
  default     = ""
}

variable "use_existing_roles" {
  description = "Flag to determine whether to use existing IAM roles"
  type        = bool
  default     = false
}
