
data "aws_region" "current" {}

resource "aws_ecs_cluster" "cluster" {
  name = "${var.name_prefix}-cluster"
  tags = merge(
    var.tags,
    {
      Purpose = "Cluster grouping all services in the environment"
    }
  )
}

# ------------------------------------------------------------------------------
# Cloudwatch
# ------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.name_prefix}"
  retention_in_days = var.log_retention_in_days
  tags = merge(
    var.tags,
    {
      Purpose = "Log group contains all log streams per environment"
    }
  )
}

# ------------------------------------------------------------------------------
# IAM - Task execution role, needed to pull ECR images etc. one role per env
# ------------------------------------------------------------------------------
resource "aws_iam_role" "execution" {
  name               = "${var.name_prefix}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.task_assume.json
  tags = merge(
    var.tags,
    {
      Purpose = "Needed to pull ECR images etc. one role per env"
    }
  )
}

resource "aws_iam_role_policy" "task_execution" {
  name   = "${var.name_prefix}-task-execution"
  role   = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.task_execution_permissions.json
}

# ------------------------------------------------------------------------------
# IAM - Security group for services
# ------------------------------------------------------------------------------

resource "aws_security_group" "main" {
  name        = "${aws_ecs_cluster.cluster.name}-sg"
  description = "Terraformed security group."
  vpc_id      = var.vpc_id
  tags = merge(
    var.tags,
    {
      Purpose = "Used for securing services"
    }
  )
}

resource "aws_security_group_rule" "ingress_internal_fargate" {
  count                    = length(var.alb_security_group_ids)
  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "8080"
  to_port                  = "8080"
  source_security_group_id = var.alb_security_group_ids[count.index]
}

resource "aws_security_group_rule" "ingress_internal_fargate_80" {
  count                    = length(var.alb_security_group_ids)
  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "80"
  to_port                  = "80"
  source_security_group_id = var.alb_security_group_ids[count.index]
}

#for monitoring
resource "aws_security_group_rule" "ingress_internal_fargate_9000" {
  count                    = length(var.alb_security_group_ids)
  security_group_id        = aws_security_group.main.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = "9000"
  to_port                  = "9000"
  source_security_group_id = var.alb_security_group_ids[count.index]
}

resource "aws_security_group_rule" "egress_internal" {
  security_group_id = aws_security_group.main.id

  type      = "egress"
  from_port = "0"
  to_port   = "65535"
  protocol  = "all"

  cidr_blocks = [
    "0.0.0.0/0",
  ]

  ipv6_cidr_blocks = [
    "::/0",
  ]
}



