variable "aws_managed_resource_arns" {
  description = "ARNs of an Application Load Balancers, an Amazon API Gateway stage, or an Amazon Cognito User Pool."
  type        = list(string)
  default     = []
}

variable "action_default" {
  description = "allow | block"
  type        = string
  default     = "allow"
}

variable "enable_x-forwarded-for_rule" {
  description = "true | false if rule evaluating x-forwarded-for header should be used"
  type        = bool
  default     = false
}

variable "rate_based_limit_x-forwarded-for" {
  description = "request limit per 5 minutes"
  type        = number
  default     = 5000
}

variable "action_x-forwarded-for" {
  description = "allow | block | captcha | count"
  type        = string
  default     = "count"

  validation {
    condition     = var.action_x-forwarded-for == "allow" || var.action_x-forwarded-for == "block" || var.action_x-forwarded-for == "captcha" || var.action_x-forwarded-for == "count"
    error_message = "Only (allow | block | captcha | count) are allowed."
  }
}

variable "paths_x-forwarded-for" {
  description = "List of the paths to be rated"
  type        = list(string)
  default     = []
}

variable "text_transformation_type_x-forwarded-for" {
  description = "List of text transformation types like: BASE64_DECODE, BASE64_DECODE_EXT, CMD_LINE, ... more: https://docs.aws.amazon.com/waf/latest/APIReference/API_TextTransformation.html"
  type        = list(string)
  default     = ["NONE"]
}

variable "enable_client-ip_rule" {
  description = "true | false if rule evaluating client-ip header should be used"
  type        = bool
  default     = false
}

variable "rate_based_limit_client-ip" {
  description = "request limit per 5 minutes"
  type        = number
  default     = 5000
}

variable "action_client-ip" {
  description = "allow | block | captcha | count"
  type        = string
  default     = "count"

  validation {
    condition     = var.action_client-ip == "allow" || var.action_client-ip == "block" || var.action_client-ip == "captcha" || var.action_client-ip == "count"
    error_message = "Only (allow | block | captcha | count) are allowed."
  }
}

variable "paths_client-ip" {
  description = "List of the paths to be rated"
  type        = list(string)
  default     = []
}

variable "text_transformation_type_client-ip" {
  description = "List of text transformation types like: BASE64_DECODE, BASE64_DECODE_EXT, CMD_LINE, ... more: https://docs.aws.amazon.com/waf/latest/APIReference/API_TextTransformation.html"
  type        = list(string)
  default     = ["NONE"]
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
