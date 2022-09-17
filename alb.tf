resource "aws_lb" "todo_prd_api_alb" {
  desync_mitigation_mode     = "defensive"
  drop_invalid_header_fields = "false"
  enable_deletion_protection = "false"
  enable_http2               = "true"
  enable_waf_fail_open       = "false"
  idle_timeout               = "60"
  internal                   = "false"
  ip_address_type            = "ipv4"
  load_balancer_type         = "application"
  name                       = "todo-prd-api-alb"
  preserve_host_header       = "false"
  security_groups            = ["${aws_security_group.todo_prd_front_sg.id}"]
  subnets = ["${aws_subnet.todo_prd_front_sn_a.id}", "${aws_subnet.todo_prd_front_sn_c.id}"]
}

resource "aws_lb_listener" "todo_prd_api_alb_listener" {
  certificate_arn = "${data.aws_acm_certificate.alb.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.todo_prd_api_tg.arn}"
    type             = "forward"
  }

  load_balancer_arn = "${aws_lb.todo_prd_api_alb.id}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
}

resource "aws_lb_listener_rule" "todo_prd_api_alb_listener_rule" {
  action {
    order            = "1"
    target_group_arn = "${aws_lb_target_group.todo_prd_api_tg.arn}"
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  listener_arn = "${aws_lb_listener.todo_prd_api_alb_listener.arn}"
  priority     = "1"
}

resource "aws_lb_target_group" "todo_prd_api_tg" {
  deregistration_delay = "300"

  health_check {
    enabled             = "true"
    healthy_threshold   = "2"
    interval            = "5"
    matcher             = "200"
    path                = "/api/v1/health_check"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "2"
    unhealthy_threshold = "2"
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "todo-prd-api-tg"
  port                          = "3000"
  protocol                      = "HTTP"
  protocol_version              = "HTTP1"
  slow_start                    = "0"

  stickiness {
    cookie_duration = "86400"
    enabled         = "false"
    type            = "lb_cookie"
  }

  target_type = "ip"
  vpc_id      = "${aws_vpc.todo_prd_vpc.id}"
}
