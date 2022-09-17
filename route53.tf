data "aws_route53_zone" "public" {
  name = var.my_domain
}

resource "aws_route53_record" "A_cloudfront_todo_prd_front" {
  alias {
    evaluate_target_health = "false"
    name                   = aws_cloudfront_distribution.todo_prd_front.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
  }

  name    = var.my_domain
  type    = "A"
  zone_id = data.aws_route53_zone.public.id
}

resource "aws_route53_record" "A_cloudfront_todo_prd_api_alb" {
  alias {
    evaluate_target_health = "false"
    name                   = aws_cloudfront_distribution.todo_prd_api_alb.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
  }

  name    = "api.${var.my_domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.public.id
}

resource "aws_route53_record" "A_alb_todo_prd_api_alb" {
  alias {
    evaluate_target_health = "true"
    name                   = aws_lb.todo_prd_api_alb.dns_name
    zone_id                = aws_lb.todo_prd_api_alb.zone_id
  }

  name    = "origin-api.${var.my_domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.public.id
}
