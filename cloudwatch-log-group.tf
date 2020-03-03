resource "aws_cloudwatch_log_group" "update_security_groups_lambda_log" {
  name              = "/aws/lambda/${var.name_prefix}-${var.lambda_function_name}"
  retention_in_days = 14
}