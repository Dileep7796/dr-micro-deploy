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

      image = "${aws_ecr_repository.app.repository_url}:latest"

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