resource "aws_wafv2_web_acl" "todo_prd_api_cf_waf" {
  description = "todo-prd-api-cf-waf"
  name        = "todo-prd-api-cf-waf"
  provider    = aws.virginia

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = "3"

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = "2"

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "todo-prd-api-key-rule"
    priority = "1"

    action {
      block {}
    }

    statement {
      not_statement {
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "x-api-key"
              }
            }

            positional_constraint = "EXACTLY"
            search_string         = var.x_api_key

            text_transformation {
              priority = "0"
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "todo-prd-api-key-rule"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "todo-prd-preflight-rule"
    priority = "0"

    action {
      allow {}
    }

    statement {
      byte_match_statement {
        field_to_match {
          method {}
        }
        positional_constraint = "EXACTLY"
        search_string         = "OPTIONS"

        text_transformation {
          priority = "0"
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "todo-prd-preflight-rule"
      sampled_requests_enabled   = "true"
    }
  }

  scope = "CLOUDFRONT"

  visibility_config {
    cloudwatch_metrics_enabled = "true"
    metric_name                = "todo-prd-api-cf-waf"
    sampled_requests_enabled   = "true"
  }
}

resource "aws_wafv2_web_acl" "todo_prd_front_cf_waf" {
  description = "todo-prd-front-cf-waf"
  name        = "todo-prd-front-cf-waf"
  provider    = aws.virginia

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesAmazonIpReputationList"
    priority = "1"

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesAmazonIpReputationList"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = "0"

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = "true"
    }
  }

  scope = "CLOUDFRONT"

  visibility_config {
    cloudwatch_metrics_enabled = "true"
    metric_name                = "todo-prd-front-cf-waf"
    sampled_requests_enabled   = "true"
  }
}

resource "aws_wafv2_web_acl" "todo_prd_api_alb_waf" {
  description = "todo-prd-api-alb-waf"
  name        = "todo-prd-api-alb-waf"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
    priority = "2"

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesKnownBadInputsRuleSet"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "AWS-AWSManagedRulesSQLiRuleSet"
    priority = "1"

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "AWS-AWSManagedRulesSQLiRuleSet"
      sampled_requests_enabled   = "true"
    }
  }

  rule {
    name     = "todo-prd-alb-key-rule"
    priority = "0"

    action {
      block {}
    }

    statement {
      not_statement {
        statement {
          byte_match_statement {
            field_to_match {
              single_header {
                name = "x-via-cloudfront-key"
              }
            }

            positional_constraint = "EXACTLY"
            search_string         = var.x_via_cloudfront_key

            text_transformation {
              priority = "0"
              type     = "NONE"
            }
          }
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = "true"
      metric_name                = "todo-prd-alb-key-rule"
      sampled_requests_enabled   = "true"
    }
  }

  scope = "REGIONAL"

  visibility_config {
    cloudwatch_metrics_enabled = "true"
    metric_name                = "todo-prd-api-alb-waf"
    sampled_requests_enabled   = "true"
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.todo_prd_api_alb.arn
  web_acl_arn  = aws_wafv2_web_acl.todo_prd_api_alb_waf.arn
}

/*
Waf for CloudFront

Do not use this resource to associate a WAFv2 Web ACL with a Cloudfront Distribution. The AWS API call backing this resource notes that you should use the web_acl_id property on the cloudfront_distribution instead.
Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_association
 */
