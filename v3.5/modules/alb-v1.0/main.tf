
resource "aws_lb" "this" {
  name               = var.alb_name
  load_balancer_type = "application"
  internal           = var.internal
  security_groups    = var.security_group_ids
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(
    {
      Environment = var.env
      Name        = var.alb_name
    },
    var.tags
  )
}

resource "aws_lb_target_group" "gogs" {
  name        = var.gogs_target_group_name
  port        = var.gogs_target_group_port
  protocol    = var.gogs_target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.gogs_target_group_target_type

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = var.gogs_health_check_path
    protocol            = var.gogs_health_check_protocol
    matcher             = var.gogs_health_check_matcher
    interval            = var.gogs_health_check_interval
    timeout             = var.gogs_health_check_timeout
    healthy_threshold   = var.gogs_health_check_healthy_threshold
    unhealthy_threshold = var.gogs_health_check_unhealthy_threshold
  }

  tags = {
    Environment = var.env
    Name        = var.gogs_target_group_name
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gogs.arn
  }

  tags = {
    Environment = var.env
    Name        = "${var.alb_name}-listener-http"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gogs.arn
  }

  tags = {
    Environment = var.env
    Name        = "${var.alb_name}-listener-https"
  }
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 1

  action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.domain_name]
    }
  }

  tags = {
    Environment = var.env
    Name        = "${var.alb_name}-redirect-http-to-https"
  }
}

resource "aws_lb_target_group" "jenkins" {
  count = var.enable_jenkins ? 1 : 0

  name        = var.jenkins_target_group_name
  port        = var.jenkins_target_group_port
  protocol    = var.jenkins_target_group_protocol
  vpc_id      = var.vpc_id
  target_type = var.jenkins_target_group_target_type

  health_check {
    path                = var.jenkins_health_check_path
    protocol            = var.jenkins_health_check_protocol
    matcher             = var.jenkins_health_check_matcher
    interval            = var.jenkins_health_check_interval
    timeout             = var.jenkins_health_check_timeout
    healthy_threshold   = var.jenkins_health_check_healthy_threshold
    unhealthy_threshold = var.jenkins_health_check_unhealthy_threshold
  }

  tags = {
    Name = var.jenkins_target_group_name
  }
}

resource "aws_lb_target_group_attachment" "jenkins_instance" {
  count            = var.enable_jenkins ? 1 : 0
  target_group_arn = aws_lb_target_group.jenkins[0].arn
  target_id        = var.jenkins_instance_id
  port             = var.jenkins_target_group_port
}

resource "aws_route53_record" "alb_record" {
  zone_id = var.route53_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "jenkins_alb_record" {
  count = var.enable_jenkins ? 1 : 0

  zone_id = var.route53_zone_id
  name    = var.jenkins_domain_name
  type    = "A"

  alias {
    name                   = aws_lb.this.dns_name
    zone_id                = aws_lb.this.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener_rule" "jenkins_redirect_http_to_https" {
  count        = var.enable_jenkins ? 1 : 0
  listener_arn = aws_lb_listener.http.arn
  priority     = var.jenkins_redirect_priority

  action {
    type = "redirect"

    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
      values = [var.jenkins_domain_name]
    }
  }

  tags = {
    Name = "jenkins-lb-listener-rule-redirect-http-to-https"
  }
}

resource "aws_lb_listener_rule" "jenkins_host_rule" {
  count        = var.enable_jenkins ? 1 : 0
  listener_arn = aws_lb_listener.https.arn
  priority     = var.jenkins_host_rule_priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins[0].arn
  }

  condition {
    host_header {
      values = [var.jenkins_domain_name]
    }
  }

  depends_on = [aws_lb_target_group.jenkins]

  tags = {
    Name = "jenkins-host-header-rule"
  }
}
