# S3 verbose logging for WAF

The module is dedicated for creating resources for detailed WAF logging to S3 bucket.
In a next stage, the logs can be analysed via AWS Athena.

More information:
* [Logging web ACL traffic](https://docs.aws.amazon.com/waf/latest/developerguide/logging.html)
* [Querying AWS WAF logs](https://docs.aws.amazon.com/athena/latest/ug/waf-logs.html)

## Usage

```hcl
module "rate_based_s3_logging" {
  source = "github.com/telia-oss/ses-tf-modules//wafv2/s3-logging?ref=v1.0.3"

  s3_bucket_suffix_name = "${local.PROJECT_NAME}-${local.ENVIRONMENT}-rate-based"
  waf_acl_arn           = module.rate_based_acl.acl_arn

  tags = merge(
    {
      environment = local.ENVIRONMENT
      purpose     = "AWS rate-based ACL logging"
    }
  )
}
```
 
The above example will:
* create a bucket with the `aws-waf-logs-` prefix
* create a lifecycle configuration - by default logs are stored for 30 days
* enable logging for the ACL pointed by `waf_acl_arn` variable


## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | \>= 1.0  |
| <a name="provider_aws"></a> [aws](#provider\_aws)                         | \>= 4.38 |

