# Deployment package for 'update_security_group_rules' Lambda function.
data "archive_file" "zip" {
  output_path = "${path.module}/scripts/update_security_groups.zip"
  type        = "zip"
  
  source_file = "${path.module}/scripts/update_security_groups.py"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}