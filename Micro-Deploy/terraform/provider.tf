provider "aws" {

  region = var.aws_region

  default_tags {

    tags = {

      Project     = "micro-deploy"
      Environment = var.environment
      ManagedBy   = "Terraform"
      Owner       = "DevOps"

    }

  }

}