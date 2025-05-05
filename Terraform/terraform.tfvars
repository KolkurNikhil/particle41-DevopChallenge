region              = "ap-south-1"
vpc_cidr            = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

alb_name           = "webapp-alb"
security_group_ids = ["sg-0abc1234def5678gh"]
subnet_ids         = ["subnet-0abc1234def5678gh", "subnet-0def5678ghabc1234"]
target_group_name  = "webapp-tg"
target_group_port  = 5000
vpc_id             = "vpc-0abc1234def5678gh"
health_check_path  = "/"
listener_port      = 5000

container_name     = "webapp-container"
container_port     = 5000
host_port          = 5000
execution_role_name = "webapp-ecsTaskExecutionRole"  # Only pass role name here

project_name       = "my-webapp"
container_image    = "knikhil999/simpletimeservice:latest"
