resource "aws_lb" "ecs_alb" {
  name            = "${var.project}-lb-${var.environment}"
  security_groups = [aws_security_group.alb.id]
  subnets         = module.vpc.public_subnets
}

resource "aws_lb_target_group" "ecs_alb_tg" {
  name        = "${var.project}-lb-tg-${var.environment}"
  port        = local.application_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = module.vpc.vpc_id

  health_check {

    # port                = local.host_port
    # matcher             = local.application_matcher
    # path                = local.application_path
    interval            = local.application_interval
    healthy_threshold   = local.application_healthy_threshold
    unhealthy_threshold = local.application_unhealthy_threshold
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = local.host_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
  }
}
