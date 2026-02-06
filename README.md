# Terraform Modules

[![Terraform](https://img.shields.io/badge/Terraform-1.3%2B-623CE4?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-5.x-FF9900?logo=amazonaws&logoColor=white)](https://registry.terraform.io/providers/hashicorp/aws/latest)

This repository contains reusable Terraform modules for AWS.

## Modules

- `modules/vpc`: VPC with public/private subnets, route tables, IGW/NATGW, and optional flow logs to S3 (KMS supported).
- `modules/ec2`: EC2 instance(s) with SG, optional spot, IAM profile for SSM, EBS options, and AMI lookup.
- `modules/ec2-schedules`: EventBridge schedules to start/stop EC2 via Lambda.
- `modules/rds`: RDS standalone or Aurora cluster with optional encryption, subnet group, SG, and read replicas (MySQL/PostgreSQL).

## Usage

Each module includes a `README.md` with usage examples and variable/outputs documentation.

## Tech stack

- Terraform (HCL)
- AWS Provider
- Python (Lambda runtime for `ec2-schedules`)

## Requirements

- Terraform `>= 1.3.0`
- AWS provider `>= 5.0`

## Repository structure

```
modules/
  vpc/
  ec2/
  ec2-schedules/
  rds/
```