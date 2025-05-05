terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "aws" {
  region = var.region
  dynamic "assume_role" {
    for_each = var.aws_role_arn != "" ? [1] : []
    content {
      role_arn = var.aws_role_arn
    }
  }

  skip_credentials_validation = true
  skip_metadata_api_check     = true
}

# ✅ Fetch current AWS account ID
data "aws_caller_identity" "current" {}

module "vpc" {
  source               = "./modules/vpc"
  environment          = "prod"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  project_name         = var.project_name
  app_port             = 80
  providers = {
    aws = aws
  }
}

module "roles" {
  source        = "./modules/roles"
  service_name  = var.service_name
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

resource "aws_ecr_repository" "time_service" {
  name                 = var.service_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    ManagedBy   = "terraform"
    Environment = "prod"
    Service     = var.service_name
  }
}

# ✅ IAM Policy for ECR push permissions
resource "aws_iam_policy" "ecr_push" {
  name        = "ecr-push-${var.service_name}"
  description = "Permissions to push to ${var.service_name} ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:TagResource"  # Ensure this action is allowed
        ],
        Resource = aws_ecr_repository.time_service.arn
      }
    ]
  })

  depends_on = [aws_ecr_repository.time_service]
}

# ✅ Attach ECR push policy to both ci-user and current user (nikhil)
resource "aws_iam_user" "ci_user" {
  name = "ci-user"
}

resource "aws_iam_user_policy_attachment" "ci_user_ecr" {
  user       = aws_iam_user.ci_user.name
  policy_arn = aws_iam_policy.ecr_push.arn
}

resource "aws_iam_user_policy_attachment" "nikhil_ecr_push" {
  user       = "nikhil"  # Ensure the user is specified correctly here
  policy_arn = aws_iam_policy.ecr_push.arn
}

module "ecs" {
  source               = "./modules/ecs"
  cluster_name         = "webapp-cluster"
  task_family          = "webapp-task-def"
  cpu                  = "256"
  memory               = "512"
  execution_role_arn   = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.execution_role_name}"
  execution_role_name  = var.execution_role_name
  task_role_arn        = module.roles.ecs_task_role_arn
  container_name       = "webapp-container"
  container_image      = var.container_image
  container_port       = 80
  service_name         = "webapp-service"
  desired_count        = 2
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [module.vpc.ecs_security_group_id]
  target_group_arn     = module.alb.target_group_arn
  vpc_id               = module.vpc.vpc_id

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

output "ecr_repository_url" {
  value = aws_ecr_repository.time_service.repository_url
}

output "ecr_repository_name" {
  value = aws_ecr_repository.time_service.name
}

output "push_commands" {
  value = <<EOF
# Push commands for CI systems:
REPO=${aws_ecr_repository.time_service.repository_url}
aws ecr get-login-password | docker login --username AWS --password-stdin $REPO
docker build -t $REPO .
docker push $REPO
EOF
}

resource "aws_codebuild_project" "docker_to_ecr" {
  name        = "dockerhub-to-ecr"
  description = "Build Docker image and push to ECR"

  source {
    type            = "GITHUB"
    location        = "https://github.com/KolkurNikhil/particle41-DevopChallenge.git"
    buildspec       = "terraform/buildspec.yml"
    git_clone_depth = 1
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = var.region
    }

    environment_variable {
      name  = "ECR_REPO"
      value = aws_ecr_repository.time_service.repository_url
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  service_role = module.roles.codebuild_role_arn
}
