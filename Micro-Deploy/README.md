# Production Ready Node.js Deployment on Amazon ECS Fargate

## Overview

This repository demonstrates a production-ready deployment of a Node.js Express application on Amazon ECS Fargate using Terraform and GitHub Actions.

---

## Architecture

```
Developer

     │

Git Push

     │

GitHub Actions

     │

Docker Build

     │

Amazon ECR

     │

Terraform

     │

Amazon ECS Cluster

     │

ECS Service

     │

Fargate Tasks

     │

Application Load Balancer

     │

Users
```

---

## Tech Stack

- Node.js 22
- Express
- Docker
- Terraform
- ECS Fargate
- ECR
- CloudWatch
- IAM
- GitHub Actions

---

## Features

- Infrastructure as Code
- Multi-stage Docker build
- Non-root container
- ECS Fargate
- CloudWatch logging
- IAM least privilege
- GitHub CI/CD
- Image scanning
- Health checks
- Rolling deployment

---

## Deployment

### Clone

```bash
git clone https://github.com/<user>/micro-deploy.git
```

### Build

```bash
docker build -t micro-deploy ./app
```

### Run

```bash
docker run -p 8080:8080 micro-deploy
```

### Terraform

```bash
cd terraform

cp terraform.tfvars.example terraform.tfvars   # fill in real vpc/alb values

terraform init

terraform plan

terraform apply
```

`terraform validate` and `terraform fmt -check` don't require real AWS values, but `plan`/`apply` need `vpc_name`, `private_subnet_tag`, `alb_name`, and `alb_security_group_id` to point at your existing infrastructure.

---

## Architectural Choices & Tradeoffs

The ALB and VPC are treated as pre-existing (per the assignment), so Terraform only looks them up via data sources and creates a target group + listener rule to attach this service to the existing listener, rather than provisioning any networking. The ECS service ignores drift on `task_definition` (see `ecs.tf`) because the CI/CD pipeline updates the running task definition directly via `amazon-ecs-deploy-task-definition` — without that, a routine `terraform apply` would revert a live deployment back to the image tag Terraform originally applied. Given the time box, this doesn't include autoscaling, blue/green deployments, or a remote Terraform backend (state is local) — see Improvements below for what a production version would add. The CI/CD pipeline's deploy job assumes an `AWS_ROLE` OIDC secret is configured; without it, that job will fail, which is expected for a repo without live AWS credentials wired up.

---

## GitHub Actions

On every push to main:

- Install dependencies
- Validate Terraform
- Build Docker Image
- Scan Image
- Push to ECR
- Update ECS Task
- Deploy ECS

---

## Security

- No root container
- IAM Roles
- Security Groups
- CloudWatch Logs
- Image scanning enabled
- Private subnets
- Health checks

---

## Improvements

- Auto Scaling
- WAF
- Route53
- ACM SSL
- Blue/Green Deployment
- Terraform Remote Backend
- Secrets Manager
- AWS X-Ray
- OpenTelemetry
- Prometheus
- Grafana

---

## License

MIT