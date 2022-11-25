# Terraform module AWS documentDB cluster and instances (MongoDB compatible).

This module templates cluster and instances
## Key features
- AWS document DB
    - Create cluster
    - Create instances
    - Encryption at rest by default due to security compliance
    - Generate random password and store it (with username) in SSM under path `/${var.environment}/${var.prefix}/${var.identifier}/(password|username)`
    - (Optional)Creates Route53 record for read nad write endpoints

## Usage
There are two main parts distributed into two blocks: 1) locals{} 2) module{}
- locals block is used to configure
    - `ingress rules` to setup security groups for Aws DocumentDB(MongoDB) instances
- module block creates aws documentDB

```HCL
locals {
  ingress_rules = [
    {
      description = "Allow MongoDB incoming connection"
      from_port   = "27017"
      to_port     = "27017"
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

module "awsdocdb" {
  source = "../template/documentdb"

  environment = "dev"
  prefix = "documentdb"
  identifier = "my-db"
  username = "dodb"
  instance_class = "db.t3.medium"
  apply_immediately = true
  instance_count = 2

  vpc_id = "vpc-xxxxxxxxxxx"
  ingress_rules = local.ingress_rules
  create_dns_record = true
  domain_name = "my-domain.telia.io"
    
  tags = {
    purpose= "example_only"
  }
}
```

<br/>

# AWS DocumentDB
## Requirements

| Name                                                                      | Version  |
|---------------------------------------------------------------------------|----------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | \>= 1.0  |
| <a name="provider_aws"></a> [aws](#provider\_aws)                         | \>= 4.38 |


### Connect to AWS document DB
Download the Amazon DocumentDB Certificate Authority (CA) certificate required to authenticate to your clusterCopy \
```
get https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem
```

Connect to this cluster with the mongo shellCopy
```
mongo --ssl --host {endpointId}.eu-west-1.docdb.amazonaws.com:27017 --sslCAFile rds-combined-ca-bundle.pem --username dodb --password <insertYourPassword>
```
Connect to this cluster with an applicationCopy
```
mongodb://dodb:<insertYourPassword>@{endpointId}.cluster-cb0nhklc63kl.eu-west-1.docdb.amazonaws.com:27017/?ssl=true&ssl_ca_certs=rds-combined-ca-bundle.pem&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false
```
