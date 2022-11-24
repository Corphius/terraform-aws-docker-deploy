module "ecs" {
  source       = "terraform-aws-modules/ecs/aws"
  cluster_name = "pinnacle-${var.environment}"
}

resource "aws_ecs_task_definition" "task" {
  family = "pinnacle"
  requires_compatibilities = [
    "FARGATE",
  ]
  execution_role_arn = aws_iam_role.pinnacle_role.arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 512
  container_definitions = jsonencode([
    {
      name      = "${var.repository_name}-${var.environment}"
      image     = var.image_name
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "pinnacle"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [aws_security_group.private.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_alb_tg.arn
    container_name   = "${var.repository_name}-${var.environment}"
    container_port   = 8000
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }

}
