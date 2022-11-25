resource "aws_security_group" "docdb" {
  name        = "${var.environment}-${var.identifier}"
  description = "Allow inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description     = ingress.value["description"]
      from_port       = ingress.value["from_port"]
      to_port         = ingress.value["to_port"]
      protocol        = ingress.value["protocol"]
      cidr_blocks     = try(split(",", ingress.value["cidr_blocks"]), null)
      security_groups = try(split(",", ingress.value["security_group_ids"]), null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port       = egress.value["from_port"]
      to_port         = egress.value["to_port"]
      protocol        = egress.value["protocol"]
      cidr_blocks     = try(split(",", egress.value["cidr_blocks"]), null)
      security_groups = try(split(",", egress.value["security_group_ids"]), null)
    }
  }

  tags = var.tags
}

data "aws_route53_zone" "docdb" {
  name         = var.domain_name
  private_zone = var.is_private_zone
}

resource "aws_route53_record" "docdb_read_endpoint_dns" {
  for_each = var.create_dns_record ? toset(["read_endpoint_dns"]) : toset([])
  name     = "${var.environment}-${var.identifier}-ro.${var.domain_name}"
  type     = "CNAME"
  ttl      = "300"
  zone_id  = data.aws_route53_zone.docdb.id
  records  = [aws_docdb_cluster.docdb.reader_endpoint]
}

resource "aws_route53_record" "docdb_read_write_endpoint_dns" {
  for_each = var.create_dns_record ? toset(["read_write_endpoint_dns"]) : toset([])
  name     = "${var.environment}-${var.identifier}-rw.${var.domain_name}"
  type     = "CNAME"
  ttl      = "300"
  zone_id  = data.aws_route53_zone.docdb.id
  records  = [aws_docdb_cluster.docdb.endpoint]
}
