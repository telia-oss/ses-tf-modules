locals {
  lambda_name = "sample-request-report"
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/${local.lambda_name}.zip"
}

resource "aws_security_group" "sg_lambda" {
  name        = "${local.lambda_name}_sg"
  description = "Lambda ${local.lambda_name} SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {}
}

resource "aws_lambda_function" "sample_request_report" {
  function_name = local.lambda_name
  description   = "Sample request lambda report"
  filename      = data.archive_file.zip.output_path
  memory_size   = 128
  timeout       = 300

  runtime          = "python3.9"
  role             = aws_iam_role.sample_request_report.arn
  source_code_hash = data.archive_file.zip.output_base64sha256
  handler          = "app.lambda_handler"
  architectures    = ["arm64"]


  environment {
    variables = {
      REGION           = var.region
      PATH_PATTERNS    = var.path_patterns,
      WEB_ACL_ARN      = var.web_acl_arn
      RULE_METRIC_NAME = var.rule_metric_name
      SCOPE            = var.scope
    }
  }

  tags = merge(var.tags, {
    Name = "Lambda generating report from WAFv2 sampled requests"
  })

}
