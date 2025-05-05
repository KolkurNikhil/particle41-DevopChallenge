# # ECR Repository using variable
# resource "aws_ecr_repository" "time_service" {
#   name                 = var.service_name
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }

#   tags = {
#     ManagedBy = "terraform"
#   }
# }

# # Complete IAM policy for pushing to ECR
# resource "aws_iam_policy" "ecr_push" {
#   name        = "ecr-push-${var.service_name}"
#   description = "Permissions to push to ${var.service_name} ECR"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "ecr:GetAuthorizationToken",
#           "ecr:BatchCheckLayerAvailability",
#           "ecr:GetDownloadUrlForLayer",
#           "ecr:PutImage",
#           "ecr:InitiateLayerUpload",
#           "ecr:UploadLayerPart",
#           "ecr:CompleteLayerUpload"
#         ],
#         Resource = aws_ecr_repository.time_service.arn
#       }
#     ]
#   })
# }

# # Optional IAM user for CI/CD access
# resource "aws_iam_user" "ci_user" {
#   name = "ci-user"
# }

# resource "aws_iam_user_policy_attachment" "ci_user_ecr" {
#   user       = aws_iam_user.ci_user.name
#   policy_arn = aws_iam_policy.ecr_push.arn
# }

# # ECR Outputs
# output "ecr_repository_url" {
#   value = aws_ecr_repository.time_service.repository_url
# }

# output "ecr_repository_name" {
#   value = aws_ecr_repository.time_service.name
# }

# output "push_commands" {
#   value = <<EOF
# # Push commands for CI systems:
# REPO=${aws_ecr_repository.time_service.repository_url}
# aws ecr get-login-password | docker login --username AWS --password-stdin $REPO
# docker build -t $REPO .
# docker push $REPO
# EOF
# }
