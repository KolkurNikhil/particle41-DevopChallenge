variable "project_name" {
  type        = string
  description = "Project name prefix for resources"
}

variable "use_existing_roles" {
  type        = bool
  default     = false
  description = "Set to true to use existing IAM roles"
}