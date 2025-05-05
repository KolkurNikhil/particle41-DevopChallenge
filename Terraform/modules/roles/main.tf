# Declare the aws_caller_identity data source to fetch account details
data "aws_caller_identity" "current" {}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole-${data.aws_caller_identity.current.account_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action   = "sts:AssumeRole"
    }]
  })
}

# Attach ECR Full Access policy to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser" # Fine-grained ECR access
}

# Attach CloudWatch Logs Full Access policy to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskRole-${data.aws_caller_identity.current.account_id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action   = "sts:AssumeRole"
    }]
  })
}

# ECR Full Access Policy
resource "aws_iam_policy" "ecr_full_access" {
  name        = "ECRFullAccess-${data.aws_caller_identity.current.account_id}"
  description = "Full access to ECR repositories"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ecr:*",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}

# ECS Full Access Policy
resource "aws_iam_policy" "ecs_full_access" {
  name        = "ECSFullAccess-${data.aws_caller_identity.current.account_id}"
  description = "Full access to ECS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = "ecs:*",
        Resource = "*"
      }
    ]
  })
}

# Attach ECR Full Access policy to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_ecr" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecr_full_access.arn
}

# Attach the default ECS Task Execution Role policy
resource "aws_iam_role_policy_attachment" "ecs_execution_default" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Attach ECS Full Access policy to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_execution_ecs" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.ecs_full_access.arn
}

# You can add additional policies as needed, depending on the specifics of your environment and security requirements.
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_iam_policy" "codebuild_user_policy" {
  name        = "CodeBuildFullAccessForUser"
  description = "Allows user to create CodeBuild projects and pass roles"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "codebuild:CreateProject",
          "codebuild:DeleteProject",
          "codebuild:UpdateProject",
          "codebuild:StartBuild",
          "codebuild:BatchGetProjects",
          "codebuild:BatchGetBuilds"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = "iam:PassRole",
        Resource = "arn:aws:iam::352437221780:role/codebuild-service-role"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_codebuild_user_policy" {
  user       = "nikhil"
  policy_arn = aws_iam_policy.codebuild_user_policy.arn
}

