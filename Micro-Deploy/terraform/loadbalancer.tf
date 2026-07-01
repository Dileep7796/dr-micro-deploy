#############################################
# Target Group
#############################################
# The ALB itself already exists (see data.tf); we only create the target
# group and a listener rule so the existing ALB can route traffic to this
# service's Fargate tasks.

resource "aws_lb_target_group" "app" {

  name = "${var.service_name}-tg"

  port = var.container_port

  protocol = "HTTP"

  vpc_id = data.aws_vpc.existing.id

  target_type = "ip"

  health_check {

    path = "/health"

    protocol = "HTTP"

    matcher = "200"

    interval = 30

    timeout = 5

    healthy_threshold = 2

    unhealthy_threshold = 3

  }

  tags = {

    Name = "${var.service_name}-tg"

  }

}

#############################################
# Existing ALB Listener (looked up, not created)
#############################################

data "aws_lb_listener" "existing" {

  load_balancer_arn = data.aws_lb.alb.arn

  port = var.alb_listener_port

}

#############################################
# Listener Rule -> forwards matching traffic to this service's target group
#############################################

resource "aws_lb_listener_rule" "app" {

  listener_arn = data.aws_lb_listener.existing.arn

  priority = var.listener_rule_priority

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.app.arn

  }

  condition {

    path_pattern {

      values = ["/*"]

    }

  }

}
