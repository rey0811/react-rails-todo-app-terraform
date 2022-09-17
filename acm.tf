data "aws_acm_certificate" "cloudfront" {
  provider    = aws.virginia
  domain      = "${var.my_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

data "aws_acm_certificate" "alb" {
  domain      = "${var.my_domain}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
