variable "name_prefix" {
  description = "Prefix used with ACL name"
  default     = ""
  type        = string
}

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
}

variable "capacity" {
  description = "WCUs capacity"
  default     = 500
  type        = number
}

variable "config" {
  description = "Rate based ACL custom rule group"
  type        = list(any)
  default     = []
}

variable "enable_ip_whitelisting_x-forwarded-for" {
  description = "true | false if the x-forwarded-for whitelisting rule should be created with the priority 0, first ip will be taken from the x-forwarded-for header"
  type        = bool
  default     = false
}

variable "enable_ip_whitelisting_client-ip" {
  description = "true | false if the client-ip whitelisting rule should be created with the priority 1"
  type        = bool
  default     = false
}

variable "ip_whitelist_set_x-forwarded-for" {
  description = "Set of IPs used in the whitelisting x-forwarded-for rule in CIDR format a.b.c.d/32"
  type        = list(string)
  default     = []
}

variable "ip_whitelist_set_client-ip" {
  description = "Set of IPs used in the whitelisting client-ip rule in CIDR format a.b.c.d/32"
  type        = list(string)
  default     = []
}

# SNS alerting
variable "enable_x-forwarded-for_alert" {
  description = "True/False to create Cloudwatch Alert for x-forwarded-for BlockedRequests limit"
  type        = bool
  default     = false
}
variable "percent_threshold_x-forwarded-for" {
  description = "Percent threshold to trigger alert for x-forwarded-for"
  type        = number
  default     = 90
}

variable "x-forwarded-for_alert_sns_arn" {
  description = "If set, alerts are sent into this SNS topic"
  type        = list(string)
  default     = []

}

variable "enable_client-ip_alert" {
  description = "True/False to create Cloudwatch Alert for client-ip BlockedRequests limit"
  type        = bool
  default     = false
}
variable "percent_threshold_client-ip" {
  description = "Percent threshold to trigger alert for client-ip"
  type        = number
  default     = 90
}

variable "client-ip_alert_sns_arn" {
  description = "If set, alerts are sent into this SNS topic"
  type        = list(string)
  default     = []
}

variable "enable_rate-based-rule-group_alert" {
  description = "True/False to create Cloudwatch Alert for rate-based-rule-group BlockedRequests limit"
  type        = bool
  default     = false
}
variable "percent_threshold_rate-based-rule-group" {
  description = "Percent threshold to trigger alert for rate-based-rule-group"
  type        = number
  default     = 90
}

variable "rate-based-rule-group_alert_sns_arn" {
  description = "If set, alerts are sent into this SNS topic"
  type        = list(string)
  default     = []
}
