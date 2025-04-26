output "ecs_task_execution_role_arn" {
  value = var.use_existing_roles ? data.aws_iam_role.existing_execution_role[0].arn : aws_iam_role.ecs_task_execution_role[0].arn
}

output "ecs_task_execution_role_name" {
  value = var.use_existing_roles ? data.aws_iam_role.existing_execution_role[0].name : aws_iam_role.ecs_task_execution_role[0].name
}

output "ecs_task_role_arn" {
  value = var.use_existing_roles ? data.aws_iam_role.existing_task_role[0].arn : aws_iam_role.ecs_task_role[0].arn
}

output "ecs_task_role_name" {
  value = var.use_existing_roles ? data.aws_iam_role.existing_task_role[0].name : aws_iam_role.ecs_task_role[0].name
}