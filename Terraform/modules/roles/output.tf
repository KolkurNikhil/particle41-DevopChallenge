output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS Task Execution Role"
  value = try(
    var.use_existing_roles ? data.aws_iam_role.existing_execution_role[0].arn : aws_iam_role.ecs_task_execution_role[0].arn,
    null
  )
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS Task Role"
  value = try(
    var.use_existing_roles ? data.aws_iam_role.existing_task_role[0].arn : aws_iam_role.ecs_task_role[0].arn,
    null
  )
}