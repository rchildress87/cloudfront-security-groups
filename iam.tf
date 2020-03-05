resource "aws_iam_role" "update_security_group_ingress_rules" {
  name                = var.iam_role_name
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
  tags                = var.input_tags
}

resource "aws_iam_policy" "allow_cloudwatch_logging" {
  name        = var.iam_policy_name_allow_cloudwatch_logging
  path        = "/"
  description = "Minimum access levels required write to Amazon CloudWatch logs for monitoring AWS Lambda functions."
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
}

resource "aws_iam_policy" "allow_security_group_describe" {
  name        = var.iam_policy_name_allow_sg_describe
  path        = "/"
  description = "Minimum access levels required read EC2 security groups."
  policy      = jsonencode({
    "Version"   = "2012-10-17",
    "Statement" = [{
      "Effect"   = "Allow",
      "Action"   = "ec2:DescribeSecurityGroups",
      "Resource" = "*"
    }]
  })
}

resource "aws_iam_policy" "allow_security_group_ingress_rules_update" {
  name        = var.iam_policy_name_allow_sg_ingress_rules_update
  path        = "/"
  description = "Minimum access levels required to update EC2 security groups' ingress rules."

  # Todo: Set resource = to specific security group ARNs rather than * and dont build arn from strings, reference objects instead.
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
}

resource "aws_iam_role_policy_attachment" "attach_policy_logging" {
  role        = aws_iam_role.update_security_group_ingress_rules.name
  policy_arn  = aws_iam_policy.allow_cloudwatch_logging.arn
}

resource "aws_iam_role_policy_attachment" "attach_policy_security_group_describe" {
  role        = aws_iam_role.update_security_group_ingress_rules.name
  policy_arn  = aws_iam_policy.allow_security_group_describe.arn
}

resource "aws_iam_role_policy_attachment" "attach_policy_security_group_updates" {
  role        = aws_iam_role.update_security_group_ingress_rules.name
  policy_arn  = aws_iam_policy.allow_security_group_ingress_rules_update.arn
}