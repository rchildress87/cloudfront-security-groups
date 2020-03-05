resource "aws_security_group" "allow_cloudfront_global_ips" {
  for_each = toset(var.permitted_protocols)

  name        = "${var.group_name_global}-${each.key}"
  description = "Allow ingress ${each.key} traffic from Amazon CloudFront global IP ranges."
  vpc_id      = data.aws_vpc.selected.id
  tags = merge(
    {
      Name        = var.cloudfront_sg_global_tag
      AutoUpdate  = "true"
      Protocol    = each.key
    },
    var.input_tags
  )
}

resource "aws_security_group" "allow_cloudfront_regional_ips" {
  for_each = toset(var.permitted_protocols)

  name        = "${var.group_name_regional}-${each.key}"
  description = "Allow ingress ${each.key} traffic from Amazon CloudFront regional IP ranges."
  vpc_id      = data.aws_vpc.selected.id
  tags = merge(
    {
      Name        = var.cloudfront_sg_regional_tag
      AutoUpdate  = "true"
      Protocol    = each.key
    },
    var.input_tags
  )
}