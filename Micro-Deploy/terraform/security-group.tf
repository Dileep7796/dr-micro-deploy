resource "aws_security_group" "ecs" {

  name = "${var.service_name}-sg"

  description = "Security Group for ECS Tasks"

  vpc_id = data.aws_vpc.existing.id

  ingress {

    description = "Allow traffic from ALB"

    from_port = var.container_port

    to_port = var.container_port

    protocol = "tcp"

    security_groups = [

      var.alb_security_group_id

    ]

  }

  egress {

    description = "Outbound Internet"

    from_port = 0

    to_port = 0

    protocol = "-1"

    cidr_blocks = [

      "0.0.0.0/0"

    ]

  }

  tags = {

    Name = "${var.service_name}-sg"

  }

}