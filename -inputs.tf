variable "aws_region" {
  description = "The AWS region in which the VPC and all related resources will be created."
  type        = string
}

variable "ec2_sg_name_global" {
  default     = "allow-cloudfront-global-ips"
  description = "Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront global IP address ranges. Will be suffixed by permitted protocol."
  type        = string
}

variable "ec2_sg_name_regional" {
  default     = "allow-cloudfront-regional-ips"
  description = "Group name given to the security groups(s) that allow ingress traffic from Amazon CloudFront regional IP address ranges. Will be suffixed by permitted protocol."
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

variable "permitted_protocols" {
  default     = ["http","https"] # Only HTTP and HTTPS are supported by update_security_groups.py
  description = "List of protocols to be allowed ingressly from CloudFront. Only http and https are currently supported."
  type        = set(string)
}

variable "vpc_id" {
  description = "ID of target VPC in which to create security groups and rules."
  type        = string
}