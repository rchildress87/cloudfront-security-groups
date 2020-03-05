resource "aws_cloudwatch_log_group" "update_security_groups_lambda_log" {
  name              = "/aws/lambda/${aws_lambda_function.update_security_group_rules.function_name}"
  retention_in_days = 14
  tags              = var.input_tags
}