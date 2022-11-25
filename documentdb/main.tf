resource "aws_docdb_subnet_group" "docdb" {
  for_each   = length(var.subnet_ids) == 0 ? toset([]) : toset(["docdb"])
  name       = "${var.environment}-${var.prefix}-${var.identifier}"
  subnet_ids = var.subnet_ids

  tags = var.tags
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "${var.environment}-${var.prefix}-${var.identifier}"
  engine                  = "docdb"
  db_subnet_group_name    = length(var.subnet_ids) == 0 ? null : aws_docdb_subnet_group.docdb["docdb"].name
  master_username         = var.username
  master_password         = random_password.generated_docdb_password.result
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = true
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.docdb.arn
  vpc_security_group_ids  = [aws_security_group.docdb.id]

  tags = var.tags
}

resource "aws_docdb_cluster_instance" "docdb" {
  for_each                     = { for i in range(var.instance_count) : (i + 1) => {} }
  identifier                   = "${var.environment}-${var.prefix}-${var.identifier}-${each.key}"
  cluster_identifier           = aws_docdb_cluster.docdb.id
  instance_class               = var.instance_class
  availability_zone            = var.availability_zone
  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  preferred_maintenance_window = var.preferred_maintenance_window

  tags = var.tags
}



