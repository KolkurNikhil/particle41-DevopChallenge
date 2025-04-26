resource "aws_ecr_repository" "webapp" {
  name                 = "webapp-${var.service_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  # Prevent accidental deletion (comment this out if you want Terraform to manage deletion)
  # lifecycle {
  #   prevent_destroy = true
  # }
}

resource "aws_ecs_cluster" "webapp_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "webapp_task" {
  family                   = var.task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name         = var.container_name
    image        = "${aws_ecr_repository.webapp.repository_url}:latest"
    essential    = true
    startTimeout = 300
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    }]
    environment = var.container_environment
    
    # Minimal logging (systemd driver doesn't require CloudWatch)
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-create-group" = "true"
        "awslogs-region"      = var.region
        "awslogs-group"       = "/ecs/${var.task_family}"
        "awslogs-stream-prefix" = "ecs"
      }
    }
    
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port} || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])
}

resource "aws_ecs_service" "webapp_service" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.webapp_cluster.id
  task_definition = aws_ecs_task_definition.webapp_task.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  depends_on = [aws_ecr_repository.webapp]
}

resource "aws_iam_role_policy_attachment" "ecr_access" {
  role       = split("/", var.execution_role_arn)[length(split("/", var.execution_role_arn))-1]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}