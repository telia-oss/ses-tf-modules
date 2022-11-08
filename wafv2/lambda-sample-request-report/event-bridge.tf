resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFrom-${aws_cloudwatch_event_rule.sample_request_report.name}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_request_report.arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.sample_request_report.arn
}

resource "aws_cloudwatch_event_rule" "sample_request_report" {
  name                = "sample-request-report"
  description         = "run scheduled every 2 hours"
  schedule_expression = "rate(2 hours)"
}

resource "aws_cloudwatch_event_target" "sample_request_report" {
  target_id = aws_lambda_function.sample_request_report.function_name
  rule      = aws_cloudwatch_event_rule.sample_request_report.name
  arn       = aws_lambda_function.sample_request_report.arn
}
