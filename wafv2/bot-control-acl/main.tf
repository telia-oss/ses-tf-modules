resource "aws_wafv2_web_acl" "aws_managed" {
  for_each = { for r in var.aws_managed : r.name => r }

  name        = each.value.name
  description = each.value.description
  scope       = each.value.scope

  dynamic "default_action" {
    for_each = each.value["default_action"] == "allow" ? ["allow"] : []
    content {
      allow {}
    }
  }

  dynamic "default_action" {
    for_each = each.value["default_action"] == "block" ? ["block"] : []
    content {
      block {}
    }
  }


  dynamic "rule" {
    for_each = { for idx, r in each.value.rules : (idx + 1) => r }
    content {
      name     = rule.value.name
      priority = tonumber(rule.key)

      dynamic "override_action" {
        for_each = rule.value.override_action == "count" ? ["count"] : []
        content {
          count {}
        }
      }
      dynamic "override_action" {
        for_each = rule.value.override_action == "none" ? ["none"] : []
        content {
          none {}
        }
      }


      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"

          dynamic "excluded_rule" {
            for_each = rule.value.rule_names

            content {
              name = excluded_rule.value
            }
          }

        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = rule.value.cloudwatch_metrics_enabled
        metric_name                = "${var.environment}-${rule.value.name}"
        sampled_requests_enabled   = rule.value.sampled_requests_enabled
      }
    }
  }


  tags = var.tags

  visibility_config {
    cloudwatch_metrics_enabled = each.value["cloudwatch_metrics_enabled"]
    metric_name                = "${var.environment}-${each.value.name}"
    sampled_requests_enabled   = each.value["sampled_requests_enabled"]
  }
}

resource "aws_wafv2_web_acl_association" "resource_association" {
  for_each     = { for r in var.aws_managed : r.name => r if var.aws_managed_enable_association }
  resource_arn = var.aws_managed_resource_arn
  web_acl_arn  = aws_wafv2_web_acl.aws_managed[each.key].arn
}

