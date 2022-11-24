## Rate Based ACL

## Usage

### Rate Based ACL

In general, two scenarios have been addressed:
1. WAF is associated with a resource (e.g ALB) behind a proxy and the client address must be taken from the x-forwarded-for header.
2. WAF is associated with a resource (e. ALB) used directly by clients. 
The example is describing the both use cases, usually you will need only one.

```terraform
module "rate_based_acl" {
  source = "../wafv2/rate-based-acl"

  aws_managed_resource_arns = [module.main.external_lb_arn, module.main.products2_lb_arn]
  environment               = local.ENVIRONMENT

  # global rule settings for x-forwarded-for,
  # paths_x-forwarded-for variable has not been set so it will work for all paths
  enable_x-forwarded-for_rule = true
  rate_based_limit_x-forwarded-for = 200

  # global rule settings for client IP
  # paths_client-ip will generate scope-down statements which will narrow down to the defined paths
  enable_client-ip_rule = true
  rate_based_limit_client-ip = 200
  paths_client-ip = ["/shop/api/v2/cart/phone/add", "/shop/api/v2/cart/phone/addaaaa"]


  tags = merge(
    {
      terraform   = "True"
      environment = local.ENVIRONMENT
      purpose     = "AWS rate-based ACL"
    }
  )
}
```

### Rate Based ACL with Custom Rule Group
This rule group is intended to be used with rate based acl to allow fine grained configuration.
The `config` variable allows to configure limit per paths.
The `aggregate_key_type` is indicating if the IP address should be taken from the x-forwarded-for header (`FORWARDED_IP`).

```terraform

module "rate-based-acl-with-custom-rule-group" {
  source = "../wafv2/rate-based-acl"

  aws_managed_resource_arns = [module.main.external_lb_arn, module.main.products2_lb_arn]
  environment               = local.ENVIRONMENT

  #global rule settings for x-forwarded-for
  enable_x-forwarded-for_rule = true
  rate_based_limit_x-forwarded-for = 200
  paths_x-forwarded-for = ["/shop/api/v2/cart/phone/add", "/shop/api/v2/cart/phone/abcd"]
  
  config = [
    {
      rule_name = "test-api"
      paths = ["/aaa/bbb/ccc", "test-1"]
      action = "block"
      limit = 300
      aggregate_key_type = "FORWARDED_IP" // (FORWARDED_IP | IP)
      text_transformations = ["NONE"]
    }
  ]
  
  tags = merge(
    {
      terraform   = "True"
      environment = local.ENVIRONMENT
      purpose     = "AWS rate-based ACL"
    }
  )
}

```

## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | \>= 1.0  |
| <a name="provider_aws"></a> [aws](#provider\_aws)                         | \>= 4.38 |
