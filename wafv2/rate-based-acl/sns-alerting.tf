resource "aws_cloudwatch_metric_alarm" "x-forwarded-for" {
  for_each            = var.enable_x-forwarded-for_alert ? toset(["x-forwarded-for"]) : []
  alarm_name          = length(var.name_prefix) == 0 ? "x-forwarded-for" : "${var.name_prefix}-x-forwarded-for"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = var.percent_threshold_x-forwarded-for
  alarm_description   = "This metric monitors WAF ACL x-forwarded-for BlockedRequests limit"
  alarm_actions       = var.x-forwarded-for_alert_sns_arn

  metric_query {
    id          = "e1"
    expression  = "m1/${var.rate_based_limit_x-forwarded-for}*100"
    label       = "Percentage of blocked requests - ${var.environment}-x-forwarded-for"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "BlockedRequests"
      namespace   = "AWS/WAFV2"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        Rule = "${var.environment}-x-forwarded-for"
      }
    }
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "client-ip" {
  for_each            = var.enable_client-ip_alert ? toset(["client-ip"]) : []
  alarm_name          = length(var.name_prefix) == 0 ? "client-ip" : "${var.name_prefix}-client-ip"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = var.percent_threshold_client-ip
  alarm_description   = "This metric monitors WAF ACL client-ip BlockedRequests limit"
  alarm_actions       = var.client-ip_alert_sns_arn

  metric_query {
    id          = "e1"
    expression  = "m1/${var.rate_based_limit_client-ip}*100"
    label       = "Percentage of blocked requests - ${var.environment}-client-ip"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "BlockedRequests"
      namespace   = "AWS/WAFV2"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        Rule = "${var.environment}-client-ip"
      }
    }
  }

  tags = var.tags
}

locals {
  # returns min value from all rules limits
  rule_limits_min_value = min([for c in var.config : c["limit"]]...)
}

resource "aws_cloudwatch_metric_alarm" "rate-based-rule-group" {
  for_each            = var.enable_rate-based-rule-group_alert ? toset(["rate-based-rule-group"]) : []
  alarm_name          = length(var.name_prefix) == 0 ? "rate-based-rule-group" : "${var.name_prefix}-rate-based-rule-group"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  threshold           = var.percent_threshold_rate-based-rule-group
  alarm_description   = "This metric monitors WAF ACL rate-based-rule-group BlockedRequests limit"
  alarm_actions       = var.rate-based-rule-group_alert_sns_arn

  metric_query {
    id          = "e1"
    expression  = "m1/${local.rule_limits_min_value}*100"
    label       = "Percentage of blocked requests - rate-based-rule-group"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "BlockedRequests"
      namespace   = "AWS/WAFV2"
      period      = "300"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        RuleGroup = "${var.environment}-rate-based-rule-group"
      }
    }
  }

  tags = var.tags
}
