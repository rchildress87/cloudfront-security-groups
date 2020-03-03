resource "aws_security_group" "allow_cloudfront_global_ips" {
  count = length(var.permitted_protocols)

  name        = "${var.name_prefix}-allow-cloudfront-global-ips-${element(var.permitted_protocols, count.index)}"
  description = "Allow ingress ${element(var.permitted_protocols, count.index)} traffic from Amazon CloudFront global IP ranges."
  vpc_id      = var.target_vpc_id
  tags = {
    Name        = "cloudfront_g"
    AutoUpdate  = "true"
    Protocol    = "${element(var.permitted_protocols, count.index)}"
  }
}

resource "aws_security_group" "allow_cloudfront_regional_ips" {
  count = length(var.permitted_protocols)

  name        = "${var.name_prefix}-allow-cloudfront-regional-ips-${element(var.permitted_protocols, count.index)}"
  description = "Allow ingress ${element(var.permitted_protocols, count.index)} traffic from Amazon CloudFront regional IP ranges."
  vpc_id      = var.target_vpc_id
  tags = {
    Name        = "cloudfront_r"
    AutoUpdate  = "true"
    Protocol    = "${element(var.permitted_protocols, count.index)}"
  }
}