# Terraform Strapi Deployment (Private EC2 with ALB)

## Overview

This project provisions infrastructure on AWS using Terraform to deploy a **Strapi application running in Docker on a private EC2 instance**.

The application is exposed through a **public Application Load Balancer**, while the EC2 instance remains secure inside a **private subnet**. A **NAT Gateway** allows outbound internet access for package installation and Docker image downloads.

---

## Architecture

Internet
→ Application Load Balancer (Public Subnets)
→ Target Group
→ Private EC2 Instance (Docker + Strapi)
→ NAT Gateway (Outbound Internet)

---

## Resources Created

* VPC
* Public Subnet (AZ-a)
* Public Subnet (AZ-b)
* Private Subnet
* Internet Gateway
* NAT Gateway
* Security Groups
* Application Load Balancer
* Target Group + Listener
* Private EC2 Instance
* Docker + Strapi (via user_data)

---

## Project Structure

```
terraform-strapi/
│
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── networking.tf
├── security.tf
├── compute.tf
├── alb.tf
├── outputs.tf
└── user_data.sh
```

---

## Prerequisites

Install the following:

* Terraform
* AWS CLI
* AWS account configured

Configure AWS credentials:

```
aws configure
```

---

## Create Key Pair

```
aws ec2 create-key-pair \
  --key-name strapi-key \
  --query 'KeyMaterial' \
  --output text > strapi-key.pem
```

```
chmod 400 strapi-key.pem
```

---

## Deployment Steps

Initialize Terraform:

```
terraform init
```

Validate configuration:

```
terraform validate
```

Preview changes:

```
terraform plan
```

Deploy infrastructure:

```
terraform apply
```

---

## Access the Application

After deployment, Terraform will output:

```
alb_dns_name
```

Open in browser:

```
http://<alb_dns_name>
```

Strapi should be running on port **1337** behind the load balancer.

---

## Security Design

ALB Security Group:

* Allows HTTP (80) from internet

EC2 Security Group:

* Allows traffic only from ALB on port 1337
* No public access to EC2

Private EC2 has outbound internet via NAT Gateway.

---

## Environment Configuration

Environment-specific values are managed using:

```
terraform.tfvars
```

Example variables:

* AWS region
* instance type
* CIDR ranges
* Strapi port
* environment name

This allows easy reuse for:

* dev
* staging
* production

---

## Destroy Infrastructure

To remove all resources:

```
terraform destroy
```

---

## Author

Terraform Strapi Infrastructure Deployment
