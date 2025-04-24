resource "aws_ecr_repository" "time_service" {
  name                 = "simpletimeservice"
  image_tag_mutability = "MUTABLE"  

  image_scanning_configuration {
    scan_on_push = true  
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}