# # provider "docker" {
# #   registry_auth {
# #     address     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.ap-south-1.amazonaws.com"
# #     config_file = pathexpand("~/.docker/config.json")
# #   }
# # }
# data "aws_caller_identity" "current" {}

# resource "aws_ecr_repository" "webapp" {
#   name = "webapp-webapp-service"
# }

# resource "docker_image" "webapp" {
#   name = "${aws_ecr_repository.webapp.repository_url}:latest"
  
#   build {
#      context    = "/d/particle41-DevopChallenge/APP"  # Your exact Docker context path
#     dockerfile = "/d/particle41-DevopChallenge/APP/Dockerfile"  # Full path to Dockerfile
    
#     # Optional: Add build args if needed
#     build_args = {
#       NODE_ENV = "production"
#     }
    
#     # Optional: Add labels
#     label = {
#       maintainer = "your-email@example.com"
#     }
#   }
# }

# resource "docker_registry_image" "webapp" {
#   name          = docker_image.webapp.name
#   keep_remotely = true  # Important: Keeps image in ECR when destroying Terraform
# }

# output "ecr_image_url" {
#   value = docker_image.webapp.name
# }