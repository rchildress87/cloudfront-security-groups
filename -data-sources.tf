# Deployment package for 'update_security_group_rules' Lambda function.
data "archive_file" "zip" {
  output_path = "${path.module}/scripts/update_security_groups.zip"
  source_file = "${path.module}/scripts/update_security_groups.py"
  type        = "zip"
}

# TODO: Is aws_caller_identity the best way to get the current account ID? Used by module to build IAM policy resource strings.

data "aws_vpc" "selected" {
  id = var.vpc_id
}