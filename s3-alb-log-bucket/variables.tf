variable "aws_region" {
  description = "AWS region to use for all resources"
  type        = string
}

variable "global_name" {
  description = "Global name of this project/account with environment"
  type        = string
}

variable "global_project" {
  description = "Global name of this project (without environment)"
  type        = string
}

variable "local_environment" {
  description = "Local name of this environment (eg, prod, stage, dev, feature1)"
  type        = string
}

variable "create_logs_bucket" {
  description = "Specify true to create S3 logs bucket"
  default     = false
  type        = bool
}

variable "force_destroy" {
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
  type        = bool
}

variable "enable_lifecycle" {
  description = "Specify if lifecycle policy is enabled"
  default     = false
  type        = bool
}

variable "lifecycle_expire_after" {
  description = "Set amount of days to keep objects"
  default     = 365
  type        = number
}

variable "logs_bucket_tags" {
  description = "Map of tags to assign to S3 logs bucket"
  type        = map(string)
  default     = {}
}

variable "custom_lifecycle" {
  description = "A state of lifecycle"
  default     = false
  type        = bool
}

variable "expiration_days" {
  description = "Expiration for objects in days."
  default     = 30
  type        = number
}
