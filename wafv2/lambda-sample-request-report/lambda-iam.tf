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

data "aws_iam_policy_document" "sample_request_report" {
  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:*",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "wafv2:GetSampledRequests"
    ]

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role" "sample_request_report" {
  name               = local.lambda_name
  assume_role_policy = data.aws_iam_policy_document.assume.json
  description        = "AIM role for ${local.lambda_name}"
  tags               = var.tags
}

resource "aws_iam_role_policy" "sample_request_report" {
  name   = local.lambda_name
  role   = aws_iam_role.sample_request_report.name
  policy = data.aws_iam_policy_document.sample_request_report.json
}
