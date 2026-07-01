#############################################
# ECS Cluster
#############################################

resource "aws_ecs_cluster" "this" {

  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = var.cluster_name
  }
}

#############################################
# ECS Task Definition
#############################################

resource "aws_ecs_task_definition" "this" {

  family = var.task_family

  network_mode = "awsvpc"

  requires_compatibilities = [
    "FARGATE"
  ]

  cpu = var.cpu

  memory = var.memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn

  task_role_arn = aws_iam_role.ecs_task_role.arn

  runtime_platform {

    cpu_architecture = "X86_64"

    operating_system_family = "LINUX"

  }

  container_definitions = jsonencode([

    {

      name = var.container_name

      image = "${aws_ecr_repository.app.repository_url}:${var.image_tag}"

      essential = true

      portMappings = [

        {

          containerPort = var.container_port

          hostPort = var.container_port

          protocol = "tcp"

        }

      ]

      environment = [

        {

          name = "PORT"

          value = tostring(var.container_port)

        },

        {

          name = "APP_NAME"

          value = var.container_name

        }

      ]

      logConfiguration = {

        logDriver = "awslogs"

        options = {

          awslogs-group = aws_cloudwatch_log_group.ecs.name

          awslogs-region = data.aws_region.current.name

          awslogs-stream-prefix = "ecs"

        }

      }

      healthCheck = {

        command = [

          "CMD-SHELL",

          "wget --spider http://localhost:${var.container_port}/health || exit 1"

        ]

        interval = 30

        timeout = 5

        retries = 3

        startPeriod = 20

      }

    }

  ])

  tags = {

    Name = var.task_family

  }

}

#############################################
# ECS Service
#############################################
# Runs the task definition on Fargate and registers tasks with the
# target group that's attached to the existing ALB (see loadbalancer.tf).

resource "aws_ecs_service" "this" {

  name = var.service_name

  cluster = aws_ecs_cluster.this.id

  task_definition = aws_ecs_task_definition.this.arn

  desired_count = var.desired_count

  launch_type = "FARGATE"

  network_configuration {

    subnets = data.aws_subnets.private.ids

    security_groups = [aws_security_group.ecs.id]

    assign_public_ip = false

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.app.arn

    container_name = var.container_name

    container_port = var.container_port

  }

  deployment_minimum_healthy_percent = 100

  deployment_maximum_percent = 200

  depends_on = [aws_lb_listener_rule.app]

  lifecycle {
    # The CI/CD pipeline registers new task definition revisions and updates
    # the running service directly via `amazon-ecs-deploy-task-definition`.
    # Ignoring drift here keeps `terraform apply` from reverting a live
    # deployment back to the revision Terraform originally created.
    ignore_changes = [task_definition]
  }

  tags = {

    Name = var.service_name

  }

}