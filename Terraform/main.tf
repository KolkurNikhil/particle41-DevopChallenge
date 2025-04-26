provider "aws" {
  region = var.region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "vpc" {
  source               = "./modules/vpc"
  environment = "prod"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name 
  app_port            = 80 
  providers = {
    aws = aws
  }
}
module "roles" {
  source       = "./modules/roles"
  project_name = "webapp"
  region       = "ap-south-1"
}
module "ecs" {
  source             = "./modules/ecs"
  cluster_name       = "webapp-cluster"
  task_family        = "webapp-task-def"
  cpu                = "256"
  memory             = "512"
  execution_role_arn = module.roles.ecs_task_execution_role_arn
  task_role_arn      = module.roles.ecs_task_role_arn
  container_name     = "webapp-container"
  container_image    = var.container_image
  container_port     = 80
  service_name       = "webapp-service"
  desired_count      = 2
  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.vpc.ecs_security_group_id]
  target_group_arn   = module.alb.target_group_arn
  vpc_id             = module.vpc.vpc_id

  container_environment = [
    {
      name  = "ENV"
      value = "production"
    },
    {
      name  = "LOG_LEVEL"
      value = "info"
    }
  ]
}




module "alb" {
  source             = "./modules/alb"
  alb_name           = "webapp-alb"
  security_group_ids = [module.vpc.alb_security_group_id]
  subnet_ids         = module.vpc.public_subnet_ids
  target_group_name  = "webapp-tg"
  target_group_port  = 80
  vpc_id             = module.vpc.vpc_id
  health_check_path  = "/"
  listener_port      = 80
}
