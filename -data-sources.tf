# Deployment package for 'update_security_group_rules' Lambda function.
data "archive_file" "zip" {
  output_path = "${path.module}/scripts/update_security_groups.zip"
  source_file = "${path.module}/scripts/update_security_groups.py"
  type        = "zip"
}

# TODO: Is aws_caller_identity the best way to get the current account ID? Used by module to build IAM policy resource strings.
data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "aws_region" "selected" {
  name = var.aws_region
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}