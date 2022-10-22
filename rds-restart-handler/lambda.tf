locals {
  rds_event_handler_lambda_name = "rds_event_handler"
}

data "archive_file" "zip" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/${local.rds_event_handler_lambda_name}.zip"
}

resource "aws_security_group" "sg_lambda" {
  name        = "${local.rds_event_handler_lambda_name}_sg"
  description = "Lambda ${local.rds_event_handler_lambda_name} SG"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {}
}

resource "aws_lambda_function" "rds_event_handler" {
  function_name = local.rds_event_handler_lambda_name
  description   = "Lambda handling events from RDS and restarting ECS services"
  filename      = data.archive_file.zip.output_path
  memory_size   = 128
  timeout       = 300

  runtime          = "python3.9"
  role             = aws_iam_role.lambda_role.arn
  source_code_hash = data.archive_file.zip.output_base64sha256
  handler          = "main.lambda_handler"
  architectures    = ["arm64"]


  environment {
    variables = {
      RDS_ECS_MAP = jsonencode(var.rds_ecs_map)
    }
  }

  tags = merge(var.tags, {
    Name = "Lambda handling events from RDS and restarting ECS services"
  })

}
