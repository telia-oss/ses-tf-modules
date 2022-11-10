locals {
  s3_bucket_name = "aws-waf-logs-${var.s3_bucket_suffix_name}"
}

resource "aws_s3_bucket" "waf_logs" {
  bucket = local.s3_bucket_name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = local.s3_bucket_name

  rule {
    apply_server_side_encryption_by_default {
      #SSE-S3 due to costs
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block_public" {

  bucket = local.s3_bucket_name

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_wafv2_web_acl_logging_configuration" "s3_logs" {
  log_destination_configs = [aws_s3_bucket.waf_logs.arn]
  resource_arn            = var.waf_acl_arn
}

resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_config" {
  bucket = aws_s3_bucket.waf_logs.bucket

  rule {
    id = "waf_logs"

    filter {
      prefix = var.s3_lifecycle_expiration_prefix
    }

    expiration {
      days = var.s3_lifecycle_expiration_days
    }

    status = var.s3_lifecycle_status
  }

}
