
locals {
  execution_role_name = "${var.project_name}-ecsTaskExecutionRole"
  task_role_name      = "${var.project_name}-ecsTaskRole"
}

# Only try to find existing roles if explicitly requested
data "aws_iam_role" "existing_execution_role" {
  count = var.use_existing_roles ? 1 : 0
  name  = local.execution_role_name
}

data "aws_iam_role" "existing_task_role" {
  count = var.use_existing_roles ? 1 : 0
  name  = local.task_role_name
}

# Create roles unless using existing ones
resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.use_existing_roles ? 0 : 1
  name  = local.execution_role_name
  path  = "/${var.project_name}/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role" "ecs_task_role" {
  count = var.use_existing_roles ? 0 : 1
  name  = local.task_role_name
  path  = "/${var.project_name}/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    ManagedBy = "Terraform"
  }
}

# Policy attachments
resource "aws_iam_role_policy_attachment" "execution_policy" {
  count = var.use_existing_roles ? 0 : 1
  role  = aws_iam_role.ecs_task_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "task_policy" {
  count = var.use_existing_roles ? 0 : 1
  role  = aws_iam_role.ecs_task_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}