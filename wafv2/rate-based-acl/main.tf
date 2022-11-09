resource "aws_wafv2_web_acl" "rate_based" {
  name        = "rate-based"
  description = "Rate based ACL"
  scope       = "REGIONAL"

  dynamic "default_action" {
    for_each = var.action_default == "allow" ? ["allow"] : []
    content {
      allow {}
    }
  }

  dynamic "default_action" {
    for_each = var.action_default == "block" ? ["block"] : []
    content {
      allow {}
    }
  }


  rule {
    name     = "x-forwarded-for"
    priority = 1

    dynamic "action" {
      for_each = var.action_x-forwarded-for == "allow" ? ["allow"] : []
      content {
        allow {}
      }
    }

    dynamic "action" {
      for_each = var.action_x-forwarded-for == "block" ? ["block"] : []
      content {
        block {}
      }
    }

    dynamic "action" {
      for_each = var.action_x-forwarded-for == "count" ? ["count"] : []
      content {
        count {}
      }
    }

    dynamic "action" {
      for_each = var.action_x-forwarded-for == "captcha" ? ["captcha"] : []
      content {
        captcha {}
      }
    }

    statement {
      rate_based_statement {

        limit              = var.rate_based_limit
        aggregate_key_type = "FORWARDED_IP"

        forwarded_ip_config {
          fallback_behavior = "NO_MATCH"
          header_name       = "X-Forwarded-For"
        }

        dynamic "scope_down_statement" {
          for_each = length(var.paths) > 0 ? ["scope_down_statement"] : []
          content {
            or_statement {
              dynamic "statement" {
                for_each = var.paths
                content {
                  byte_match_statement {
                    field_to_match {
                      uri_path {}
                    }
                    positional_constraint = "CONTAINS"
                    search_string         = statement.value

                    dynamic "text_transformation" {
                      for_each = { for idx, tr_type in var.text_transformation_type : (idx) => tr_type }
                      content {
                        priority = tonumber(text_transformation.key)
                        type     = text_transformation.value
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.environment}-x-forwarded-for"
      sampled_requests_enabled   = false
    }
  }

  tags = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-rate-based"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "resource_association" {
  for_each     = toset(var.aws_managed_resource_arns)
  resource_arn = each.value
  web_acl_arn  = aws_wafv2_web_acl.rate_based.arn
}
