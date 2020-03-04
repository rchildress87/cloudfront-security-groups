resource "aws_iam_role" "update_security_group_ingress_rules" {
  name                = var.iam_role_name
  assume_role_policy  = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags                = var.input_tags
}

resource "aws_iam_policy" "allow_cloudwatch_logging" {
  name        = var.iam_policy_name_allow_cloudwatch_logging
  path        = "/"
  description = "Minimum access levels required write to Amazon CloudWatch logs for monitoring AWS Lambda functions."
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ],
    "Resource": "arn:aws:logs:*:*:*"
  }
}
EOF
}

resource "aws_iam_policy" "allow_security_group_ingress_rules_update" {
  name        = var.iam_policy_name_allow_sg_ingress_rules_update
  path        = "/"
  description = "Minimum access levels required to update EC2 security group ingress rules."
  # Todo: Can the resource in this policy be more granular?
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress"
    ],
    "Resource": "*"
  }
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_policy_logging" {
  role        = aws_iam_role.update_security_group_ingress_rules.name
  policy_arn  = aws_iam_policy.allow_cloudwatch_logging.arn
}

resource "aws_iam_role_policy_attachment" "attach_policy_security_group_updates" {
  role        = aws_iam_role.update_security_group_ingress_rules.name
  policy_arn  = aws_iam_policy.allow_security_group_ingress_rules_update.arn
}