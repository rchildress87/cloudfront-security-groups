# Deployment package for 'update_security_group_rules' Lambda function.
data "archive_file" "zip" {
  output_path = "./modules/cloudfront-security-groups/scripts/update_security_groups.zip"
  source_file = "./modules/cloudfront-security-groups/scripts/update_security_groups.py"
  type        = "zip"
}

resource "aws_lambda_function" "update_security_group_rules" {
  depends_on          = [
    aws_iam_role_policy_attachment.attach_policy_logging,
    aws_iam_role_policy_attachment.attach_policy_security_group_updates,
    aws_cloudwatch_log_group.update_security_groups_lambda_log
  ]

  description         = "Finds all EC2 security groups tagged name=cloudfront_g or name=cloudfront_r and protocol=http or protocol=https and creates rules, as needed, for ingress traffic on 80/tcp or 443/tcp from published Amazon CloudFront IP address ranges."
  function_name       = "${var.name_prefix}-${var.lambda_function_name}"
  filename            = data.archive_file.zip.output_path
  source_code_hash    = data.archive_file.zip.output_base64sha256
  handler             = "update_security_groups.lambda_handler"
  role                = aws_iam_role.update_security_group_ingress_rules.arn
  runtime             = "python3.8"   # Script seems to work as intended in python 3.8 but it was written for python 2.7.
  timeout             = 4             # Adjust as needed. The default, 3, is not quite enough for the four security zones created (~3177ms).
  memory_size         = 128           # Adjust as needed. Script uses ~87MB for four security zones. 128MB is minimum allowed.
}

resource "aws_lambda_permission" "allow_invocation_by_sns" {
  statement_id  = "${var.name_prefix}-AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_security_group_rules.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic_subscription.amazon_ip_space_changed.arn
}

resource "null_resource" "invoke_lambda_function" {
  depends_on = [
    aws_lambda_function.update_security_group_rules,
    aws_security_group.allow_cloudfront_global_ips,
    aws_security_group.allow_cloudfront_regional_ips
  ]

  provisioner "local-exec" {
    command = "./modules/cloudfront-security-groups/scripts/invoke_function.sh ${var.name_prefix}-${var.lambda_function_name}"
  }
}