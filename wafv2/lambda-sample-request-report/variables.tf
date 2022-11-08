variable "tags" {
  type    = map(string)
  default = {}
}

variable "region" {
  description = "Region where lambda shall be running."
  type        = string
}

variable "path_patterns" {
  description = "Path pattern to be looks up among sampled requests"
  type        = string
  default     = ""
}

variable "web_acl_arn" {
  description = "WEB ACL arn"
  type        = string
}

variable "rule_metric_name" {
  description = "Metric name"
  type        = string
}

variable "scope" {
  description = "Either REGIONAL or CLOUDFRONT"
  type        = string
  default     = "REGIONAL"
}

