resource "aws_security_group" "alb" {
  name        = "alb-sg-${var.environment}"
  description = "Security group for ALB in ${var.environment}"
  vpc_id      = aws_vpc.main.id

  # Change from port 80 to 5000
  ingress {
    from_port   = 5000  # Updated
    to_port     = 5000  # Updated
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-sg-${var.environment}"
    Environment = var.environment
  }
}


resource "aws_security_group" "vpc_endpoint" {
  name_prefix = "vpce-sg-"
  vpc_id      = aws_vpc.main.id
  
  # Allow HTTPS from within the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.main.cidr_block]  # Restrict to VPC CIDR
  }
  
  # Allow outbound HTTPS (needed for ECR)
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoint-sg"
  }
}

resource "aws_security_group" "ecs" {
  name_prefix = "ecs-sg-${var.environment}-"
  description = "Security group for ECS tasks (${var.environment})"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 5000  # Changed from var.app_port
    to_port         = 5000  # Changed from var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]  # Allow traffic from ALB
  }

  # Temporary wide egress for setup
  egress {
    description = "Temporary wide egress for setup"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # DNS resolution
  egress {
    description = "Allow DNS"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "ecs-sg-${var.environment}"
    Environment = var.environment
  }
}
