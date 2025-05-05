variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "webapp-cluster"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "task_family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = "webapp-task-def"
}
# variables.tf
variable "ecr_repository_exists" {
  description = "Set to true if repository already exists"
  type        = bool
  default     = true # Default to safe mode
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory (in MiB) for the task"
  type        = string
  default     = "512"
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate with the target group"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the task role"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "webapp-container"
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = "aws_account_id.dkr.ecr.region.amazonaws.com/repository_name:latest"
}


variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 5000
}


variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "simpletimeservice" # Changed from webapp-service
}

variable "desired_count" {
  description = "Number of desired tasks"
  type        = number
  default     = 2
}

variable "subnet_ids" {
  description = "List of subnet IDs for the service"
  type        = list(string)
}



variable "target_group_arn" {
  description = "ARN of the target group for the load balancer"
  type        = string
}

variable "container_environment" {
  description = "Environment variables for the ECS container"
  type        = list(object({
    name  = string
    value = string
  }))
  default     = []
}

variable "use_existing_ecr" {
  description = "Set to true to use existing ECR repository"
  type        = bool
  default     = false
}

variable "ecr_repository_name" {
  description = "Custom ECR repository name (defaults to webapp-<service_name>)"
  type        = string
  default     = null
}

variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
  default     = "latest"
}
variable "execution_role_name" {
  description = "Name of the ECS Task Execution Role"
  type        = string
}
variable "security_group_ids" {
  type = list(string)
}
