resource "aws_iam_role" "ecs_execution_role" {

  name = "${var.service_name}-execution-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ecs-tasks.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "execution_role_policy" {

  role = aws_iam_role.ecs_execution_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"

}

resource "aws_iam_role" "ecs_task_role" {

  name = "${var.service_name}-task-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Principal = {

          Service = "ecs-tasks.amazonaws.com"

        }

        Action = "sts:AssumeRole"

      }

    ]

  })

}

resource "aws_iam_policy" "application_policy" {

  name = "${var.service_name}-policy"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "logs:CreateLogStream",
          "logs:PutLogEvents"

        ]

        Resource = "*"

      }

    ]

  })

}

resource "aws_iam_role_policy_attachment" "application_policy_attachment" {

  role = aws_iam_role.ecs_task_role.name

  policy_arn = aws_iam_policy.application_policy.arn

}