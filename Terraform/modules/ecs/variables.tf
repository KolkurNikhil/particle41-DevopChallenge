variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "webapp-cluster"
}

variable "task_family" {
  description = "Family name for the ECS task definition"
  type        = string
  default     = "webapp-task-def"
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
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 80
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = "webapp-service"
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

variable "security_group_ids" {
  description = "List of security group IDs for the service"
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
