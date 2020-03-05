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
    "Resource": [
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.selected.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.update_security_groups_lambda_log.name}",
      "arn:${data.aws_partition.current.partition}:logs:${data.aws_region.selected.name}:${data.aws_caller_identity.current.account_id}:log-group:${aws_cloudwatch_log_group.update_security_groups_lambda_log.name}:log-stream:*"
    ]
  }
}
EOF
#     arn:${Partition}:logs:${Region}:${Account}:log-group:${LogGroupName}
}

resource "aws_iam_policy" "allow_security_group_describe" {
  name        = var.iam_policy_name_allow_sg_describe
  path        = "/"
  description = "Minimum access levels required read EC2 security groups."
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "ec2:DescribeSecurityGroups",
    "Resource": "*"
  }
}
EOF
}

resource "aws_iam_policy" "allow_security_group_ingress_rules_update" {
  name        = var.iam_policy_name_allow_sg_ingress_rules_update
  path        = "/"
  description = "Minimum access levels required to update EC2 security groups' ingress rules."
  # Todo: Use specific security group ids.
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress"
    ],
    "Resource": "arn:${data.aws_partition.current.partition}:ec2:${data.aws_region.selected.name}:${data.aws_caller_identity.current.account_id}:security-group/*"
  }
}
EOF
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