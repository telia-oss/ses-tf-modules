output "alb_target_group_blue_arn_suffix" {
  description = "TG arn suffix"
  value       = aws_lb_target_group.blue.arn_suffix
}

output "alb_target_group_blue_arn" {
  description = "TG arn"
  value       = aws_lb_target_group.blue.arn
}
output "ecs_service" {
  value = aws_ecs_service.service
}

output "ecs_task_definition" {
  value = aws_ecs_task_definition.task
}
