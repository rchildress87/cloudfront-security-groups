resource "aws_security_group" "allow_cloudfront_global_ips" {
  for_each = toset(var.permitted_protocols)

  description = "Allow ingress ${each.key} traffic from Amazon CloudFront global IP ranges."
  name        = "${var.ec2_sg_name_global}-${each.key}"
  tags = merge(
    {
      Name        = var.ec2_sg_name_global
      AutoUpdate  = "true"
      Protocol    = each.key
    },
    var.input_tags
  )
  vpc_id      = data.aws_vpc.selected.id
}

resource "aws_security_group" "allow_cloudfront_regional_ips" {
  for_each = toset(var.permitted_protocols)

  name        = "${var.ec2_sg_name_regional}-${each.key}"
  description = "Allow ingress ${each.key} traffic from Amazon CloudFront regional IP ranges."
  tags = merge(
    {
      Name        = var.ec2_sg_name_regional
      AutoUpdate  = "true"
      Protocol    = each.key
    },
    var.input_tags
  )
  vpc_id      = data.aws_vpc.selected.id
}