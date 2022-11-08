output "logs_s3_bucket_id" {
  description = "The name of logs bucket"
  value       = aws_s3_bucket.logs["logs_bucket"].id
}

output "logs_s3_bucket_arn" {
  description = "ARN of logs bucket"
  value       = aws_s3_bucket.logs["logs_bucket"].arn
}

output "logs_s3_bucket_domain_name" {
  description = "Domain name of logs bucket"
  value       = aws_s3_bucket.logs["logs_bucket"].bucket_domain_name
}
