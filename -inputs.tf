variable "aws_region" {
  description = "The AWS region in which the VPC and all related resources will be created."
  type        = string
}

variable "cloudfront_sg_global_tag" {
  default     = "cloudfront_g"
  description = "Name tag given to the security groups responsible for ingress traffic from Amazon CloudFront global IP addresses."
  type        = string
}

variable "cloudfront_sg_regional_tag" {
  default     = "cloudfront_r"
  description = "Name tag given to the security groups responsible for ingress traffic from Amazon CloudFront regional IP addresses."
  type        = string
}

variable "group_name_global" {
  default     = "allow-cloudfront-global-ips"
  description = "Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront global IP address ranges. Will be suffixed by permitted protocol."
  type        = string
}

variable "group_name_regional" {
  default     = "allow-cloudfront-regional-ips"
  description = "Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront regional IP address ranges. Will be suffixed by permitted protocol."
  type        = string
}

variable "iam_policy_name_allow_cloudwatch_logging" {
  default     = "custom-AllowCloudwatchLogsPartialWriteAccess"
  description = "Name given to IAM policy that allows for partial write access to CloudWatch logs."
  type        = string
}

variable "iam_policy_name_allow_sg_describe" {
  default     = "custom-AllowEC2SecurityGroupDescribe"
  description = "Name given to custom IAM policy that allows describing EC2 security groups." 
  type        = string
}

variable "iam_policy_name_allow_sg_ingress_rules_update" {
  default     = "custom-AllowEC2SecurityGroupIngressRulesUpdate"
  description = "Name given to custom IAM policy that allows listing, creating, and updating EC2 security group ingress rules."
  type        = string
}

variable "iam_role_name" {
  default     = "update-security-group-ingress-rules"
  description = "Name given to IAM role for updating ingress rules in security groups."
  type        = string
}

variable "input_tags" {
  default = {
    Developer   = "GenesisFunction"
    Provisioner = "Terraform"
  }
  description = "Map of tags to apply to all taggable resources."
  type        = map(string)
}

variable "lambda_function_name" {
  default     = "update-security-group-rules"
  description = "The name of the Lambda function used to create security groups and rules."
  type        = string
}

variable "lambda_permission_name" {
  default     = "custom-AllowInvocationFromSNS"
  description = "Name of Lambda permission that allows a function to be triggered by an SNS notification."
  type        = string
}

variable "permitted_protocols" {
  default     = ["http","https"] # Only HTTP and HTTPS are supported by update_security_groups.py
  description = "List of protocols to be allowed ingressly from CloudFront."
  type        = list
}

variable "vpc_id" {
  description = "ID of target VPC in which to create security groups and rules."
  type        = string
}