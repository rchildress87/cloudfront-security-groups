resource "aws_iam_role" "update_ec2_sg_ingress_rules" {
  assume_role_policy  = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [{
      "Effect"    = "Allow",
      "Action"    = "sts:AssumeRole",
      "Principal" = {
        "Service" = "lambda.amazonaws.com"
      },
      "Sid"       = ""
    }]
  })

  name  = "${var.lambda_function_name}-role"
  tags  = var.input_tags
}

resource "aws_iam_policy" "allow_cloudwatch_logging" {
  policy      = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [{
      "Effect" = "Allow",
      "Action" = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource" = [
        "${aws_cloudwatch_log_group.update_security_groups_lambda_log.arn}",
        "${aws_cloudwatch_log_group.update_security_groups_lambda_log.arn}:log-stream:*"
      ]
    }]
  })

  description = "Minimum permissions required for writing to the '${var.lambda_function_name}' Lambda function CloudWatch log group."
  name        = "${var.lambda_function_name}-allow-logging"
  path        = "/"
}

resource "aws_iam_policy" "allow_security_group_describe" {
  policy      = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [{
      "Effect"   = "Allow",
      "Action"   = "ec2:DescribeSecurityGroups",
      "Resource" = "*"
    }]
  })

  description = "Minimum access levels required read EC2 security groups."
  name        = "${var.lambda_function_name}-describe-ec2-security-groups"
  path        = "/"
}

resource "aws_iam_policy" "allow_security_group_ingress_rules_update" {
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [{
      "Effect" = "Allow",
      "Action" = [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress"
      ],
      "Resource" = concat(
        values(aws_security_group.allow_cloudfront_global_ips)[*].arn,
        values(aws_security_group.allow_cloudfront_regional_ips)[*].arn
      )
    }]
  })

  description = "Minimum access levels required to update EC2 security groups' ingress rules."
  name        = "${var.lambda_function_name}-allow-ec2-sg-ingress-rule-update"
  path        = "/"
}

resource "aws_iam_role_policy_attachment" "allow_logging" {
  policy_arn  = aws_iam_policy.allow_cloudwatch_logging.arn
  role        = aws_iam_role.update_ec2_sg_ingress_rules.name
}

resource "aws_iam_role_policy_attachment" "describe_ec2_security_group" {
  policy_arn  = aws_iam_policy.allow_security_group_describe.arn
  role        = aws_iam_role.update_ec2_sg_ingress_rules.name
}

resource "aws_iam_role_policy_attachment" "allow_ingress_rule_update" {
  policy_arn  = aws_iam_policy.allow_security_group_ingress_rules_update.arn
  role        = aws_iam_role.update_ec2_sg_ingress_rules.name
}