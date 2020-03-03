# cloudfront-security-groups
cloudfront-security-groups provisions new security groups for allowing ingress traffic over ports 80/tcp and 443/tcp from all global and applicable regional Amazon CloudFront published IP address ranges. The security groups are updated automatically any time the published IP address ranges (https://ip-ranges.amazonaws.com/ip-ranges.json) are updated.

### Example usage:
Create a Lamba function and related security groups to permit http and https traffic 
```module "cloudfront-security-groups" {
    source  = ...
    version = 1.0.0

    aws_region              = us-east-1
    lambda_function_name    = update-security-group-rules
    name_prefix             = var.name_prefix
    permitted_protocols     = ["http","https"]
    target_vpc_id           = vpc-a30725da
}
```