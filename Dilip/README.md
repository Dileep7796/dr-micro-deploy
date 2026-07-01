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
docker build -t micro-deploy .
```

### Run

```bash
docker run -p 8080:8080 micro-deploy
```

### Terraform

```bash
cd terraform

terraform init

terraform plan

terraform apply
```

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