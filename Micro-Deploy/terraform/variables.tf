########################################
# AWS
########################################

variable "aws_region" {

  type        = string
  description = "AWS Region"

  default = "ap-south-1"

}

########################################
# Environment
########################################

variable "environment" {

  type        = string
  description = "Deployment Environment"

  default = "dev"

}

########################################
# Existing Infrastructure
########################################

variable "vpc_name" {

  type        = string
  description = "Existing VPC Name"

}

variable "private_subnet_tag" {

  type        = string
  description = "Private subnet tag"

}

variable "alb_name" {

  type        = string
  description = "Existing ALB Name"

}

########################################
# ECS
########################################

variable "cluster_name" {

  default = "micro-cluster"

}

variable "service_name" {

  default = "micro-service"

}

variable "task_family" {

  default = "micro-task"

}


variable "container_name" {

  default = "micro-deploy"

}

variable "container_port" {

  default = 8080

}

variable "cpu" {

  default = 256

}

variable "memory" {

  default = 512

}


variable "desired_count" {

  default = 2

}

variable "alb_security_group_id" {
  description = "Existing ALB Security Group ID"
  type        = string
}

variable "alb_listener_port" {
  description = "Port of the existing ALB listener to attach the routing rule to"
  type        = number
  default     = 443
}

variable "listener_rule_priority" {
  description = "Priority for the ALB listener rule (must be unique per listener)"
  type        = number
  default     = 100
}

variable "log_retention_days" {
  description = "CloudWatch Log Retention"
  type        = number
  default     = 30
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}