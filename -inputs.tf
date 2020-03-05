variable "aws_region" {
  description = "The AWS region in which the VPC and all related resources will be created."
  type        = string
}

variable "group_name_global" {
  description = "Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront global IP address ranges. Will be suffixed by permitted protocol."
  type        = string
  default     = "allow-cloudfront-global-ips"
}

variable "group_name_regional" {
  description = "Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront regional IP address ranges. Will be suffixed by permitted protocol."
  type        = string
  default     = "allow-cloudfront-regional-ips"
}

variable "iam_policy_name_allow_cloudwatch_logging" {
  description = "Name given to IAM policy that allows for partial write access to CloudWatch logs."
  type        = string
  default     = "custom-AllowCloudwatchLogsPartialWriteAccess"
}

variable "iam_policy_name_allow_sg_describe" {
  description = "Name given to custom IAM policy that allows describing EC2 security groups." 
  type        = string
  default     = "custom-AllowEC2SecurityGroupDescribe"
}

variable "iam_policy_name_allow_sg_ingress_rules_update" {
  description = "Name given to custom IAM policy that allows listing, creating, and updating EC2 security group ingress rules."
  type        = string
  default     = "custom-AllowEC2SecurityGroupIngressRulesUpdate"
}

variable "iam_role_name" {
  description = "Name given to IAM role for updating ingress rules in security groups."
  type        = string
  default     = "update-security-group-ingress-rules"
}

variable "input_tags" {
  description = "Map of tags to apply to all taggable resources."
  type        = map(string)
  default = {
    Developer   = "GenesisFunction"
    Provisioner = "Terraform"
  }
}

variable "lambda_function_name" {
  description = "The name of the Lambda function used to create security groups and rules."
  type        = string
  default     = "update-security-group-rules"
}

variable "lambda_permission_name" {
  description = "Name of Lambda permission that allows a function to be triggered by an SNS notification."
  type        = string
  default     = "custom-AllowInvocationFromSNS"
}

#variable "name_prefix" {
#  description = "String to use as prefix on object names"
#  type        = string
#}

variable "permitted_protocols" {
  description = "List of protocols to be allowed ingressly from CloudFront."
  type        = list
  default     = ["http","https"] # Only HTTP and HTTPS are supported by update_security_groups.py
}

variable "vpc_id" {
  description = "ID of target VPC in which to create security groups and rules."
  type        = string
}