# rules priorities:
# 0,1 dedicated from whitelisting
# 2,3 dedicated to rate_based rules

resource "aws_wafv2_web_acl" "rate_based" {
  name        = length(var.name_prefix) == 0 ? "rate-based" : "${var.name_prefix}-rate-based"
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

  dynamic "rule" {
    for_each = var.enable_x-forwarded-for_rule ? ["x-forwarded-for"] : []
    content {
      name     = "x-forwarded-for"
      priority = 2

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

          limit              = var.rate_based_limit_x-forwarded-for
          aggregate_key_type = "FORWARDED_IP"

          forwarded_ip_config {
            fallback_behavior = "NO_MATCH"
            header_name       = "X-Forwarded-For"
          }

          dynamic "scope_down_statement" {
            for_each = length(var.paths_x-forwarded-for) > 0 ? ["scope_down_statement"] : []
            content {
              or_statement {
                dynamic "statement" {
                  for_each = var.paths_x-forwarded-for
                  content {
                    byte_match_statement {
                      field_to_match {
                        uri_path {}
                      }
                      positional_constraint = "CONTAINS"
                      search_string         = statement.value

                      dynamic "text_transformation" {
                        for_each = { for idx, tr_type in var.text_transformation_type_x-forwarded-for : (idx) => tr_type }
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
  }

  dynamic "rule" {
    for_each = var.enable_client-ip_rule ? ["client-ip"] : []
    content {
      name     = "client-ip"
      priority = 3

      dynamic "action" {
        for_each = var.action_client-ip == "allow" ? ["allow"] : []
        content {
          allow {}
        }
      }

      dynamic "action" {
        for_each = var.action_client-ip == "block" ? ["block"] : []
        content {
          block {}
        }
      }

      dynamic "action" {
        for_each = var.action_client-ip == "count" ? ["count"] : []
        content {
          count {}
        }
      }

      dynamic "action" {
        for_each = var.action_client-ip == "captcha" ? ["captcha"] : []
        content {
          captcha {}
        }
      }

      statement {
        rate_based_statement {

          limit              = var.rate_based_limit_client-ip
          aggregate_key_type = "IP"

          dynamic "scope_down_statement" {
            for_each = length(var.paths_client-ip) > 0 ? ["scope_down_statement"] : []
            content {
              or_statement {
                dynamic "statement" {
                  for_each = var.paths_client-ip
                  content {
                    byte_match_statement {
                      field_to_match {
                        uri_path {}
                      }
                      positional_constraint = "CONTAINS"
                      search_string         = statement.value

                      dynamic "text_transformation" {
                        for_each = { for idx, tr_type in var.text_transformation_type_client-ip : (idx) => tr_type }
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
        metric_name                = "${var.environment}-client-ip"
        sampled_requests_enabled   = false
      }

    }
  }


  dynamic "rule" {
    for_each = var.enable_ip_whitelisting_x-forwarded-for ? ["x-forwarded-for"] : []

    content {
      name     = "whitelist-x-forwarded-for"
      priority = 0

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.whitelist_x-forwarded-for["x-forwarded-for"].arn
          ip_set_forwarded_ip_config {
            header_name       = "X-Forwarded-For"
            fallback_behavior = "NO_MATCH"
            position          = "FIRST"
          }
        }

      }
      action {
        allow {}
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.environment}-whitelisting-x-forwarded-for"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {
    for_each = var.enable_ip_whitelisting_client-ip ? ["client-ip"] : []

    content {
      name     = "whitelist-client-ip"
      priority = 1

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.whitelist_client-ip["client-ip"].arn
        }

      }
      action {
        allow {}
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.environment}-whitelisting-client-ip"
        sampled_requests_enabled   = false
      }
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

resource "aws_wafv2_ip_set" "whitelist_client-ip" {
  for_each = var.enable_ip_whitelisting_client-ip ? toset(["client-ip"]) : toset([])

  name               = "Whitelist"
  description        = "Whitelist IP set for client-ip"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.ip_whitelist_set_client-ip

  tags = var.tags
}


resource "aws_wafv2_ip_set" "whitelist_x-forwarded-for" {
  for_each = var.enable_ip_whitelisting_x-forwarded-for ? toset(["x-forwarded-for"]) : toset([])

  name               = "Whitelist"
  description        = "Whitelist IP set for x-forwarded-for"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.ip_whitelist_set_x-forwarded-for

  tags = var.tags
}
