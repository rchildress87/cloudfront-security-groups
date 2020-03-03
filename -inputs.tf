variable "aws_region" {
  description = "The AWS region in which the VPC and all related resources will be created."
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function used to create security groups and rules."
  type        = string
  default     = "update-security-group-rules"
}

variable "name_prefix" {
  description = "String to use as prefix on object names"
  type        = string
}

variable "permitted_protocols" {
  description = "List of protocols to be allowed ingressly from CloudFront."
  type        = list
  default     = ["http","https"] # Only HTTP and HTTPS are supported by update_security_groups.py
}

variable "target_vpc_id" {
  description = "ID of target VPC in which to create security groups and rules."
  type        = string
}