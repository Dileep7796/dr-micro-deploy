

data "aws_vpc" "existing" {

  filter {

    name   = "tag:Name"
    values = [var.vpc_name]

  }

}


data "aws_subnets" "private" {

  filter {

    name = "vpc-id"

    values = [
      data.aws_vpc.existing.id
    ]

  }

  filter {

    name = "tag:Name"

    values = [
      var.private_subnet_tag
    ]

  }

}


data "aws_lb" "alb" {

  name = var.alb_name

}



data "aws_caller_identity" "current" {}



data "aws_region" "current" {}