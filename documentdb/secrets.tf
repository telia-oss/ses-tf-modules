resource "random_password" "generated_docdb_password" {
  length           = 16
  upper            = true
  lower            = true
  number           = true
  special          = var.use_special
  override_special = var.override_special
}

resource "aws_ssm_parameter" "docdb_username" {
  name  = "/${var.environment}/${var.prefix}/${var.identifier}/username"
  value = var.username
  type  = "String"
  tags  = var.tags
}

resource "aws_ssm_parameter" "docdb_password" {
  name  = "/${var.environment}/${var.prefix}/${var.identifier}/password"
  value = random_password.generated_docdb_password.result
  type  = "SecureString"
  tags  = var.tags

  lifecycle {
    ignore_changes = [value]
  }

}

resource "aws_kms_key" "docdb" {
  description             = "${var.environment}-${var.prefix}-${var.identifier}-KMS"
  deletion_window_in_days = 10
  tags                    = var.tags
}
