resource "aws_cloudwatch_log_group" "ecs" {

  name = "/ecs/${var.service_name}"

  retention_in_days = var.log_retention_days

  tags = {

    Name = "${var.service_name}-logs"

  }

}