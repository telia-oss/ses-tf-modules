data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "x-forwarded-for" {
  for_each            = var.enable_x-forwarded-for_alert ? toset(["x-forwarded-for"]) : []
  alarm_name          = length(var.name_prefix) == 0 ? "x-forwarded-for" : "${var.name_prefix}-x-forwarded-for"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.alert_threshold_x-forwarded-for
  alarm_description   = "This metric monitors WAF ACL x-forwarded-for BlockedRequests limit"
  alarm_actions       = var.x-forwarded-for_alert_sns_arn

  dimensions = {
    Region = data.aws_region.current.name
    Rule   = local.metric_name["x-forwarded-for"]
    WebACL = aws_wafv2_web_acl.rate_based.name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "client-ip" {
  for_each            = var.enable_client-ip_alert ? toset(["client-ip"]) : []
  alarm_name          = length(var.name_prefix) == 0 ? "client-ip" : "${var.name_prefix}-client-ip"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.alert_threshold_client-ip
  alarm_description   = "This metric monitors WAF ACL client-ip BlockedRequests limit"
  alarm_actions       = var.client-ip_alert_sns_arn

  dimensions = {
    Region = data.aws_region.current.name
    Rule   = local.metric_name["client-ip"]
    WebACL = aws_wafv2_web_acl.rate_based.name
  }

  tags = var.tags
}

resource "aws_cloudwatch_metric_alarm" "rate-based-rule-group" {
  for_each            = var.enable_rate-based-rule-group_alert ? toset(["rate-based-rule-group"]) : []
  alarm_name          = length(var.name_prefix) == 0 ? "rate-based-rule-group" : "${var.name_prefix}-rate-based-rule-group"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = "60"
  statistic           = "Sum"
  threshold           = var.alert_threshold_rate-based-rule-group
  alarm_description   = "This metric monitors WAF ACL client-ip BlockedRequests limit"
  alarm_actions       = var.rate-based-rule-group_alert_sns_arn

  dimensions = {
    Region = data.aws_region.current.name
    Rule   = local.metric_name["rule-group"]
    WebACL = aws_wafv2_web_acl.rate_based.name
  }

  tags = var.tags
}
