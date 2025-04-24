
# Check for existing execution role
data "aws_iam_role" "existing_execution_role" {
  count = var.use_existing_roles ? 1 : 0
  name  = "${var.project_name}-ecsTaskExecutionRole"

  lifecycle {
    postcondition {
      condition     = var.use_existing_roles ? self.arn != null : true
      error_message = "ECS Task Execution Role '${var.project_name}-ecsTaskExecutionRole' not found when use_existing_roles=true"
    }
  }
}

# Check for existing task role
data "aws_iam_role" "existing_task_role" {
  count = var.use_existing_roles ? 1 : 0
  name  = "${var.project_name}-ecsTaskRole"

  lifecycle {
    postcondition {
      condition     = var.use_existing_roles ? self.arn != null : true
      error_message = "ECS Task Role '${var.project_name}-ecsTaskRole' not found when use_existing_roles=true"
    }
  }
}

# Create execution role only if not using existing one
resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.use_existing_roles ? 0 : 1
  name  = "${var.project_name}-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policy to either existing or new execution role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = var.use_existing_roles ? data.aws_iam_role.existing_execution_role[0].name : aws_iam_role.ecs_task_execution_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create task role only if not using existing one
resource "aws_iam_role" "ecs_task_role" {
  count = var.use_existing_roles ? 0 : 1
  name  = "${var.project_name}-ecsTaskRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policy to either existing or new task role
resource "aws_iam_role_policy_attachment" "ecs_task_role_policy" {
  role       = var.use_existing_roles ? data.aws_iam_role.existing_task_role[0].name : aws_iam_role.ecs_task_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}