# Sample request report

Sampled request are available for 3 hour.
The module contains a scheduled lambda function which is capturing the samples and is placing it to the CloudWatch logs.
More information can be found here [Viewing a sample of web requests] (https://docs.aws.amazon.com/waf/latest/developerguide/web-acl-testing-view-sample.html)

## Usage

```hcl

module "sample_request_report" {
  source = "../modules/waf/lambda-sample-request-report"

  path_patterns    = "shop,cart,add"
  region           = "eu-west-1"
  rule_metric_name = "${local.ENVIRONMENT}-BotControl"
  web_acl_arn      = "arn:aws:wafv2:eu-west-1:1234567890:regional/webacl/BotControl/abcdefg"
}


```

## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | \>= 1.0  |
| <a name="provider_aws"></a> [aws](#provider\_aws)                         | \>= 4.38 |

