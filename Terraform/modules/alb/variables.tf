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
  description = "VPC ID for the target group"
  type        = string
}

variable "health_check_path" {
  description = "Health check path for the target group"
  type        = string
}

variable "listener_port" {
  description = "Listener port for the ALB"
  type        = number
}
