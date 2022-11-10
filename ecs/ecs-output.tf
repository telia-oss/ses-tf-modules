output "cluster_name" {
  description = "Cluster name"
  value       = aws_ecs_cluster.cluster.name
}

output "cluster_arn" {
  description = "Cluster ARN"
  value       = aws_ecs_cluster.cluster.arn
}

output "log_group_name" {
  description = "The name of the Cloudwatch log group."
  value       = aws_cloudwatch_log_group.main.name
}

output "log_group_arn" {
  description = "The arn of the Cloudwatch log group."
  value       = aws_cloudwatch_log_group.main.arn
}


output "task_execution_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the task execution role."
  value       = aws_iam_role.execution.arn
}

output "task_execution_role_name" {
  description = "The name of the task execution role."
  value       = aws_iam_role.execution.name
}

output "aws_security_group" {
  description = "Security group ID"
  value       = aws_security_group.main.id
}

output "code_deploy_role_arn" {
  description = "Code deploy role ARN"
  value       = aws_iam_role.code_deploy.arn
}