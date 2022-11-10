output "this_security_group_id" {
  description = "The security group ID of Application Load Balancer"
  value       = module.alb_security_group.security_group_id
}

output "this_alb_arn" {
  description = "Suffix of ARN of the ALB. Useful for passing to cloudwatch Metric dimension."
  value       = module.alb.lb_arn
}

output "this_alb_https_listener_arns" {
  description = "The ARNs of the HTTPS load balancer listeners created."
  value       = module.alb.https_listener_arns
}

output "this_alb_http_listener_arns" {
  description = "The ARNs of the HTTP load balancer listeners created."
  value       = module.alb.http_tcp_listener_arns
}

output "this_alb_arn_suffix" {
  description = "Suffix of ARN of the ALB. Useful for passing to cloudwatch Metric dimension."
  value       = module.alb.lb_arn_suffix
}

output "full_url" {
  description = "Full URL of the environment"
  value       = "https://${aws_route53_record.a.fqdn}"
}

output "this_alb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}

output "this_alb_zone_id" {
  description = "The zone_id of the load balancer to assist with creating DNS records."
  value       = module.alb.lb_zone_id
}
