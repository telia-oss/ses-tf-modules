## Rate Based ACL
```terraform
module "rate_based_acl" {
  source = "../wafv2/rate-based-acl"

  aws_managed_resource_arns = [module.main.external_lb_arn, module.main.products2_lb_arn]
  environment               = local.ENVIRONMENT

  #global rule settings for x-forwarded-for
  enable_x-forwarded-for_rule = true
  rate_based_limit_x-forwarded-for = 200
  paths_x-forwarded-for = ["/shop/api/v2/cart/phone/add", "/shop/api/v2/cart/phone/addaaaa"]

  #global rule settings for client IP
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

## Rate Based ACL with Custom Rule Group
This rule group is intended to be used with rate based acl to allow fine grained configuration

### Module usage example

```terraform

module "rate-based-acl-with-custom-rule-group" {
  source = "../wafv2/rate-based-acl"

  aws_managed_resource_arns = [module.main.external_lb_arn, module.main.products2_lb_arn]
  environment               = local.ENVIRONMENT

  #global rule settings for x-forwarded-for
  enable_x-forwarded-for_rule = true
  rate_based_limit_x-forwarded-for = 200
  paths_x-forwarded-for = ["/shop/api/v2/cart/phone/add", "/shop/api/v2/cart/phone/addaaaa"]

  #global rule settings for client IP
  enable_client-ip_rule = true
  rate_based_limit_client-ip = 200
  paths_client-ip = ["/shop/api/v2/cart/phone/add", "/shop/api/v2/cart/phone/addaaaa"]

  config = [
    {
      rule_name = "test-api"
      paths = ["aaa/bb/ccc", "test-1"]
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
