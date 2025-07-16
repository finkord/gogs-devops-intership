
resource "aws_lb" "gogs" {
  name               = "gogs-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [data.terraform_remote_state.sg.outputs.alb_sg_id]
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "gogs-alb"
    Environment = var.env
  }
}

resource "aws_lb_target_group" "gogs" {
  name        = "gogs-tg"
  port        = 3000
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  target_type = "ip"

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 86400
  }

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = {
    Name = "gogs-target-group"
  }
}

resource "aws_lb_listener" "gogs_http" {
  load_balancer_arn = aws_lb.gogs.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gogs.arn
  }

  tags = {
    Name = "gogs-lb-listener-http"
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.gogs.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.terraform_remote_state.route53.outputs.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.gogs.arn
  }

  tags = {
    Name = "gogs-lb-listener-https"
  }
}

resource "aws_lb_listener_rule" "redirect_http_to_https" {
  listener_arn = aws_lb_listener.gogs_http.arn
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
      values = ["awsgogs.pp.ua"]
    }
  }

  tags = {
    Name = "gogs-lb-listener-rule-redirect-http-to-https"
  }
}

resource "aws_route53_record" "alb_record" {
  zone_id = data.terraform_remote_state.route53.outputs.route53_zone_id
  name    = "awsgogs.pp.ua"
  type    = "A"

  alias {
    name                   = aws_lb.gogs.dns_name
    zone_id                = aws_lb.gogs.zone_id
    evaluate_target_health = true
  }
}
