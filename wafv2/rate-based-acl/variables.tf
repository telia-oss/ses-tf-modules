variable "aws_managed_resource_arns" {
  description = "ARNs of an Application Load Balancers, an Amazon API Gateway stage, or an Amazon Cognito User Pool."
  type        = list(string)
  default     = []
}

variable "rate_based_limit" {
  description = "request limit per 5 minutes"
  type        = number
  default     = 5000
}

variable "action_default" {
  description = "allow | block"
  type        = string
  default     = "allow"
}

variable "action_x-forwarded-for" {
  description = "allow | block | captcha | count"
  type        = string
  default     = "count"

  validation {
    condition = var.action_x-forwarded-for == "allow" || var.action_x-forwarded-for == "block" || var.action_x-forwarded-for == "captcha" || var.action_x-forwarded-for == "count"
    error_message = "Only (allow | block | captcha | count) are allowed."
  }
}

variable "paths" {
  description = "List of the paths to be rated"
  type = list(string)
  default = []
}

variable "environment" {
  description = "Local name of this environment (eg, prod, stage, dev, feature1)."
  type        = string
}

variable "tags" {
  description = "Map of tags to assign to ALB."
  type        = map(string)
  default     = {}
}

