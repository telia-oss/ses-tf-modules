resource "aws_wafv2_rule_group" "rate-based_rule-group" {
  for_each    = length(var.config) == 0 ? [] : toset(["rate-based-rule-group"])
  name        = length(var.name_prefix) == 0 ? "rate-based-rule-group" : "${var.name_prefix}-rate-based-rule-group"
  description = "Rate based custom rule group"
  scope       = "REGIONAL"
  capacity    = var.capacity


  dynamic "rule" {
    for_each = { for idx, cfg in var.config : idx => cfg }

    content {
      name     = rule.value["rule_name"]
      priority = rule.key

      dynamic "action" {
        for_each = rule.value["action"] == "allow" ? ["allow"] : []
        content {
          allow {}
        }
      }

      dynamic "action" {
        for_each = rule.value["action"] == "block" ? ["block"] : []
        content {
          block {}
        }
      }

      dynamic "action" {
        for_each = rule.value["action"] == "count" ? ["count"] : []
        content {
          count {}
        }
      }

      dynamic "action" {
        for_each = rule.value["action"] == "captcha" ? ["captcha"] : []
        content {
          captcha {}
        }
      }

      statement {
        rate_based_statement {
          limit              = rule.value["limit"]
          aggregate_key_type = rule.value["aggregate_key_type"]

          dynamic "forwarded_ip_config" {
            for_each = rule.value["aggregate_key_type"] == "FORWARDED_IP" ? ["forwarded_ip_config"] : []
            content {
              fallback_behavior = "NO_MATCH"
              header_name       = "X-Forwarded-For"
            }
          }

          dynamic "scope_down_statement" {
            for_each = length(rule.value["paths"]) > 1 ? ["scope_down_statement"] : []
            content {
              or_statement {
                dynamic "statement" {
                  for_each = rule.value["paths"]
                  content {
                    byte_match_statement {
                      field_to_match {
                        uri_path {}
                      }
                      positional_constraint = "CONTAINS"
                      search_string         = statement.value

                      dynamic "text_transformation" {
                        for_each = { for idx, tr_type in rule.value["text_transformations"] : (idx) => tr_type }
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
          dynamic "scope_down_statement" {
            for_each = length(rule.value["paths"]) == 1 ? ["scope_down_statement"] : []
            content {
              byte_match_statement {
                field_to_match {
                  uri_path {}
                }
                positional_constraint = "CONTAINS"
                search_string         = rule.value["paths"][0]

                dynamic "text_transformation" {
                  for_each = { for idx, tr_type in rule.value["text_transformations"] : (idx) => tr_type }
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

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "rate-based-rule-group-${rule.value["rule_name"]}"
        sampled_requests_enabled   = false
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}-rate-based-rule-group"
    sampled_requests_enabled   = false
  }

  tags = merge(
    var.tags,
    {
      Purpose = "Custom rate-based rule group"
    }
  )
}
