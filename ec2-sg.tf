resource "aws_security_group" "allow_cloudfront_global_ips" {
  count = length(var.permitted_protocols)

  name        = "${var.group_name_global}-${element(var.permitted_protocols, count.index)}"
  description = "Allow ingress ${element(var.permitted_protocols, count.index)} traffic from Amazon CloudFront global IP ranges."
  vpc_id      = var.vpc_id
  tags = merge(
    {
      Name        = "cloudfront_r"
      AutoUpdate  = "true"
      Protocol    = "${element(var.permitted_protocols, count.index)}"
    },
    var.input_tags
  )
}

resource "aws_security_group" "allow_cloudfront_regional_ips" {
  count = length(var.permitted_protocols)

  name        = "${var.group_name_regional}-${element(var.permitted_protocols, count.index)}"
  description = "Allow ingress ${element(var.permitted_protocols, count.index)} traffic from Amazon CloudFront regional IP ranges."
  vpc_id      = var.vpc_id
  tags = merge(
    {
      Name        = "cloudfront_r"
      AutoUpdate  = "true"
      Protocol    = "${element(var.permitted_protocols, count.index)}"
    },
    var.input_tags
  )
}