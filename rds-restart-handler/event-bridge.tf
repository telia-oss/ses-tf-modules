resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFrom-${aws_cloudwatch_event_rule.rds_event.name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.rds_event_handler.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.rds_event.arn
}

resource "aws_cloudwatch_event_rule" "rds_event" {
  name          = "rds-events-lambda-rule"
  event_pattern = <<EOF
  {
  "source": ["aws.rds"],
  "detail-type": ["RDS DB Instance Event"]
  }
  EOF
}

resource "aws_cloudwatch_event_target" "lambda_event_handler" {
  target_id = aws_lambda_function.rds_event_handler.function_name
  rule      = aws_cloudwatch_event_rule.rds_event.name
  arn       = aws_lambda_function.rds_event_handler.arn
}
