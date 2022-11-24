# Terraform module for AWS WAF

This module templates AWS WAF manged rules
## Key features
- AWS WAF
    - Creates AWS managed group rules
    - Allows customization for each managed rule

## Usage
There is config as input for AWS WAF module. This example creates AWS managed bot rule group which counts hits for each
rule existing under this group. Enables cloudwatch metrics and disables sampling

```HCL
module "bot_managed_rule" {
  source = "../../templates/waf"

  aws_managed = [
    {
      name           = "AWSBotManagedRule"
      description    = "Custom config for bot managed rule"
      scope          = "REGIONAL"
      default_action = "allow"
      rules = [
        {
          name            = "AWSManagedRulesBotControlRuleSet"
          override_action = "count"
          rule_names = ["CategoryAdvertising", "CategoryArchiver", "CategoryContentFetcher", "CategoryEmailClient",
            "CategoryHttpLibrary", "CategoryLinkChecker", "CategoryMiscellaneous", "CategoryMonitoring",
            "CategoryScrapingFramework", "CategorySearchEngine", "CategorySecurity", "CategorySeo", "CategorySocialMedia",
            "SignalAutomatedBrowser", "SignalKnownBotDataCenter", "SignalNonBrowserUserAgent"]
          cloudwatch_metrics_enabled = true
          sampled_requests_enabled   = false
        }
      ]
    }
  ]

  environment = local.environment
  tags = merge(
    local.common_tags,
    {
      purpose = "AWS manages WAS rule group"
    }
  )
}
```



### Input variables
| Name                           | Description                                                                                       | Type         | Default | Required |
|--------------------------------|---------------------------------------------------------------------------------------------------|--------------|---------|----------|
| aws_managed                    | Environment variable identifying resource grouping.                                               | list(object) |         | yes      |
| resource_arn                   | ARN of an Application Load Balancer, an Amazon API Gateway stage, or an Amazon Cognito User Pool. | string       |         | yes      |
| aws_managed_enable_association | true to add WAF to resource / false to create WAF configuration only.                             | bool         | false   | no       |
| environment                    | Local name of this environment (eg, prod, stage, dev, feature1).                                  | string       |         | yes      |
| tags                           | Map of tags to assign to ALB.                                                                     | map(string)  |         | yes      |


## TODO
- [ ] add another tf file: `aws_rule_group.tf` to handle `aws_wafv2_rule_group`, similar to `aws_managed.tf`
