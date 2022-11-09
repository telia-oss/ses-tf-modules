variable "waf_acl_arn" {
  description = "ARN of the WAF ACL for which the S3 logging will be enabled"
  type        = string
}

variable "s3_bucket_suffix_name" {
  description = "Name of the bucket for logging. The bucket will be created with SSE-S3 encryption, aws-waf-logs- prefix will be added in module"
  type        = string

}

variable "s3_lifecycle_status" {
  description = "Enables autodeletion of logs in S3 after a number of days set in s3_lifecycle_expiration_days."
  type        = string
  default     = "Enabled"
}

variable "s3_lifecycle_expiration_prefix" {
  description = "Only objects under this prefix are included in the lifecycle"
  type        = string
  default     = "AWSLogs/"
}

variable "s3_lifecycle_expiration_days" {
  description = "Number of days for which logs are stored in S3. Defaults to 30 days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Map of tags to assign to ALB."
  type        = map(string)
  default     = {}
}

