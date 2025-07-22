

#!!!!!!!!!!!!!!!!!!!!!!
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
#!!!!!!!!!!!!!!!!!!!!!!
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

#!!!!!!!!!!!!!!!!!!!!!!
resource "aws_lb_listener_rule" "jenkins_host_rule" {
  listener_arn = aws_lb_listener.https.arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins.arn
  }

  condition {
    host_header {
      values = ["jenkins.awsgogs.pp.ua"]
    }
  }

  depends_on = [aws_lb_target_group.jenkins]

  tags = {
    Name = "jenkins-host-header-rule"
  }
}
