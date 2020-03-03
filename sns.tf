resource "aws_sns_topic_subscription" "amazon_ip_space_changed" {
  topic_arn   = "arn:aws:sns:us-east-1:806199016981:AmazonIpSpaceChanged" # Todo: Is the subscription available in different regions?
  protocol    = "lambda"
  endpoint    = aws_lambda_function.update_security_group_rules.arn
}