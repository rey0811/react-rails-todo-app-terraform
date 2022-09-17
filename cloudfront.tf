resource "aws_cloudfront_distribution" "todo_prd_front" {
  aliases = ["${var.my_domain}"]

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "0"

    forwarded_values {
      cookies {
        forward = "none"
      }

      query_string = "false"
    }

    max_ttl                = "0"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "${aws_s3_bucket.todo_prd_front.bucket_regional_domain_name}"
    viewer_protocol_policy = "allow-all"
  }

  default_root_object = "index.html"
  enabled             = "true"
  http_version        = "http2"
  is_ipv6_enabled     = "true"

  origin {
    connection_attempts      = "3"
    connection_timeout       = "10"
    domain_name              = "${aws_s3_bucket.todo_prd_front.bucket_regional_domain_name}"
    origin_id                = "${aws_s3_bucket.todo_prd_front.bucket_regional_domain_name}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.s3.cloudfront_access_identity_path
    }
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = "${data.aws_acm_certificate.cloudfront.arn}"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  web_acl_id = "${aws_wafv2_web_acl.todo_prd_front_cf_waf.arn}"
}

resource "aws_cloudfront_origin_access_identity" "s3" {
  comment = "Origin access identity for S3"
}

resource "aws_cloudfront_distribution" "todo_prd_api_alb" {
  aliases = ["api.${var.my_domain}"]

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]
    compress        = "true"
    default_ttl     = "86400"

    forwarded_values {
      cookies {
        forward = "all"
      }

      headers      = ["*"]
      query_string = "true"
    }

    max_ttl                = "31536000"
    min_ttl                = "0"
    smooth_streaming       = "false"
    target_origin_id       = "todo-prd-api-alb-origin"
    viewer_protocol_policy = "redirect-to-https"
  }

  enabled         = "true"
  http_version    = "http2"
  is_ipv6_enabled = "true"

  origin {
    connection_attempts = "3"
    connection_timeout  = "10"

    custom_header {
      name  = "x-via-cloudfront-key"
      value = "${var.x_via_cloudfront_key}"
    }

    custom_origin_config {
      http_port                = "80"
      https_port               = "443"
      origin_keepalive_timeout = "5"
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = "30"
      origin_ssl_protocols     = ["TLSv1.2"]
    }

    domain_name = "${aws_lb.todo_prd_api_alb.dns_name}"
    origin_id   = "todo-prd-api-alb-origin"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  retain_on_delete = "false"

  viewer_certificate {
    acm_certificate_arn            = "${data.aws_acm_certificate.cloudfront.arn}"
    cloudfront_default_certificate = "false"
    minimum_protocol_version       = "TLSv1.2_2021"
    ssl_support_method             = "sni-only"
  }

  web_acl_id = "${aws_wafv2_web_acl.todo_prd_api_cf_waf.arn}"
}
