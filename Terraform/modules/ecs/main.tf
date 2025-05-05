resource "aws_ecs_cluster" "main" {
  name = "simpletime-cluster"
}

resource "aws_ecs_task_definition" "webapp" {
  family                   = "simpletime-task"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = "256"
  memory                  = "512"
  execution_role_arn      = var.execution_role_arn
  task_role_arn = var.task_role_arn


  container_definitions = jsonencode([
    {
      name      = "webapp"
      image     = var.container_image # 👈 Uses the image from terraform.tfvars
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "webapp" {
  name            = "simpletime-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.webapp.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
  subnets         = var.subnet_ids
  security_groups = var.security_group_ids
  assign_public_ip = true
}

}

