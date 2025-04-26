  variable "project_name" {
    type        = string
    description = "Project name prefix for resources"
  }

  variable "use_existing_roles" {
    type        = bool
    default     = false
    description = "Set to true to use existing IAM roles"
  }

  # variable "environment" {
  #   description = "Environment (dev/stage/prod)"
  #   type        = string
  #   default     = "dev"
  # }

  variable "environment" {
    description = "Environment (dev/stage/prod)"
    type        = string
    default     = "dev"
  }

  variable "region" {
    description = "AWS region"
    type        = string
  }
  variable "enable_existing_role_check" {
    description = "Set to false to skip checking for existing roles"
    type        = bool
    default     = true
  }
variable "create_roles" {
  type        = bool
  default     = true
  description = "Set to false to skip role creation (use existing roles only)"
}