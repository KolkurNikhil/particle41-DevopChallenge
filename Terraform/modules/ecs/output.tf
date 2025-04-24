output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.webapp_cluster.id
}

output "ecs_service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.webapp_service.name
}
