data "aws_iam_policy_document" "assume" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "lambda.amazonaws.com",
      ]
    }
  }
}

data "aws_iam_policy_document" "basic" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecs:UpdateService",
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${local.rds_event_handler_lambda_name}-role"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  description        = "AIM role for ${local.rds_event_handler_lambda_name}"
  tags               = var.tags
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "${local.rds_event_handler_lambda_name}-role-policy-basic"
  role   = aws_iam_role.lambda_role.name
  policy = data.aws_iam_policy_document.basic.json
}
