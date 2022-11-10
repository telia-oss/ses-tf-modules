variable "aws_managed" {
  description = "List for managed rules as objects. Order sets priority from highest to lowest"
  type = list(object(
    {
      name           = string
      description    = string
      scope          = string
      default_action = string
      rules = list(object({
        name                       = string
        override_action            = string
        rule_names                 = list(string)
        cloudwatch_metrics_enabled = bool
        sampled_requests_enabled   = bool
      }))
      cloudwatch_metrics_enabled = string
      sampled_requests_enabled   = string
    }
  ))
  default = []
}

variable "aws_managed_resource_arn" {
  description = "ARN of an Application Load Balancer, an Amazon API Gateway stage, or an Amazon Cognito User Pool."
  type        = string
}

variable "aws_managed_enable_association" {
  description = "true to add WAF to resource / false to create WAF configuration only."
  type        = bool
  default     = false
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

