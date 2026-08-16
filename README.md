# Terraform AWS DevOps Portfolio

Infrastructure as Code project built with Terraform on AWS.

The goal of this project is to progressively build a production-like AWS infrastructure and later integrate Docker, CI/CD, high availability, security, and monitoring.

---

# 📌 Project Status

🚧 **In Progress**

## Current Progress

- [x] Terraform project initialized
- [x] AWS provider configured
- [x] Remote Terraform State with S3
- [x] S3 encryption
- [x] S3 versioning
- [x] S3 public access block
- [x] Terraform state locking
- [x] Terraform modules
- [x] VPC
- [x] Public subnet
- [x] Private subnet
- [x] Internet Gateway
- [x] Public Route Table
- [x] Security Group
- [x] SSH restricted to administrator IP
- [x] HTTP access
- [x] EC2 instance
- [x] EC2 outputs
- [x] Second Availability Zone
- [x] Second public subnet
- [x] Second private subnet
- [x] Elastic IP
- [x] NAT Gateway
- [ ] Private Route Tables
- [ ] Private EC2 without public IP
- [ ] Private subnet Internet connectivity test
- [ ] Final network architecture
- [ ] Docker
- [ ] CI/CD with GitHub Actions
- [ ] Application Load Balancer
- [ ] Auto Scaling
- [ ] CloudWatch monitoring
- [ ] Final documentation

---

# 🏗️ Architecture

## Current Architecture

```text
                         Internet
                            |
                     Internet Gateway
                            |
                     Public Route Table
                            |
                    Public Subnet
                    10.0.1.0/24
                            |
                           EC2
                            |
                           VPC
                     10.0.0.0/16
                            |
                    Private Subnet
                    10.0.2.0/24

Target Architecture

Internet
                              |
                     Internet Gateway
                              |
                +-------------+-------------+
                |                           |
              AZ-a                         AZ-b
                |                           |
        +-------+-------+           +-------+-------+
        |               |           |               |
     Public          Private      Public          Private
     Subnet          Subnet       Subnet          Subnet
   10.0.1.0/24     10.0.3.0/24  10.0.2.0/24     10.0.4.0/24
        |               |           |               |
        |              NAT         NAT*             |
        |               |           |               |
        +---------------+-----------+---------------+
                              |
                             VPC
                        10.0.0.0/16

* NAT Gateway redundancy can be added later.


---

☁️ AWS Services

Current

Amazon VPC

Amazon EC2

Amazon S3

Internet Gateway

Route Tables

Security Groups


Planned

Elastic IP

NAT Gateway

Application Load Balancer

Auto Scaling

CloudWatch

GitHub Actions

Docker



---

🌐 Network Design

VPC

CIDR: 10.0.0.0/16
Region: ca-central-1

Availability Zones

ca-central-1a
ca-central-1b

Public Subnets

Public Subnet A
10.0.1.0/24
ca-central-1a

Public Subnet B
10.0.2.0/24
ca-central-1b

Private Subnets

Private Subnet A
10.0.3.0/24
ca-central-1a

Private Subnet B
10.0.4.0/24
ca-central-1b


---

🔐 Security

SSH

SSH access is restricted to the administrator's public IP.

TCP 22
Source: ADMIN_IP/32

The project avoids exposing SSH to the entire Internet.

0.0.0.0/0 → TCP 22

is intentionally avoided.

HTTP

TCP 80
Source: 0.0.0.0/0

Outbound Traffic

EC2 instances can initiate outbound connections.

Private EC2 instances will eventually use a NAT Gateway for outbound Internet access.


---

💾 Terraform Remote State

Terraform state is stored remotely in Amazon S3.

Bucket:
terraform-aws-portfolio-tfstate-raouf

Key:
terraform-aws-portfolio/terraform.tfstate

Region:
ca-central-1

The S3 backend uses:

Server-side encryption

Versioning

Public access blocking

Terraform state locking



---

📁 Project Structure

terraform-aws-portfolio/
│
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── versions.tf
├── terraform.tfvars
├── .gitignore
├── README.md
│
└── modules/
    │
    ├── networking/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    ├── security/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── compute/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf


---

🧩 Terraform Modules

Networking Module

Responsible for:

VPC

Subnets

Internet Gateway

Route Tables

Route Table Associations


Security Module

Responsible for:

EC2 Security Group

SSH ingress

HTTP ingress

Egress rules


Compute Module

Responsible for:

EC2

Amazon Linux AMI lookup

EC2 networking

EC2 outputs



---

🖥️ Compute

The project currently deploys an Amazon Linux EC2 instance.

Instance Type:
t3.micro

The EC2 instance is currently deployed in the public subnet while the network architecture is being developed.

The final architecture will move application workloads into private subnets.


---

🔄 Private EC2 Traffic Flow

The target architecture will allow private EC2 instances to access the Internet without exposing them directly to inbound Internet traffic.

Private EC2
     |
     v
Private Route Table
     |
     v
NAT Gateway
     |
     v
Internet Gateway
     |
     v
Internet

Private EC2 instances will not have public IP addresses.


---

🧪 Validation Tests

Terraform Validation

terraform fmt
terraform validate
terraform plan

Terraform State

terraform state list

Private Connectivity

After the private architecture is deployed:

curl https://example.com

or:

sudo dnf update

The request should leave the private subnet through the NAT Gateway.


---

🔀 Git Workflow

Check repository status:

git status

Stage changes:

git add .

Commit changes:

git commit -m "feat: description"

Push to GitHub:

git push origin main


---

🚀 Roadmap

Phase 1 — Terraform Foundation

[x] Terraform initialization

[x] AWS provider

[x] Variables

[x] Outputs

[x] Terraform modules

[x] Git/GitHub


Phase 2 — Remote State

[x] S3 backend

[x] Encryption

[x] Versioning

[x] Public access block

[x] State locking


Phase 3 — Networking

[x] VPC

[x] Public subnet

[x] Private subnet

[x] Internet Gateway

[x] Public Route Table

[ ] Second Availability Zone

[ ] Second public subnet

[ ] Second private subnet

[ ] Elastic IP

[ ] NAT Gateway

[ ] Private Route Tables


Phase 4 — Security

[x] Security Group

[x] SSH restriction

[x] HTTP rule

[x] Egress rule

[ ] Private EC2 isolation


Phase 5 — Compute

[x] EC2 module

[x] Amazon Linux AMI lookup

[x] EC2 deployment

[ ] EC2 outputs

[ ] Move EC2 to private subnet

[ ] Validate private connectivity


Phase 6 — Docker

[ ] Application

[ ] Dockerfile

[ ] Docker image

[ ] Container deployment


Phase 7 — CI/CD

[ ] GitHub Actions

[ ] Terraform validation

[ ] Docker build

[ ] Automated deployment


Phase 8 — High Availability

[ ] Application Load Balancer

[ ] Target Groups

[ ] Auto Scaling Group

[ ] Multi-AZ deployment


Phase 9 — Monitoring

[ ] CloudWatch

[ ] VPC Flow Logs


Phase 10 — Documentation

[ ] Architecture diagram

[ ] AWS screenshots

[ ] Validation results

[ ] Final documentation



---

🧠 Skills Demonstrated

AWS VPC

IPv4 CIDR planning

Public and private subnet design

Availability Zones

Internet Gateway

NAT Gateway

Route Tables

Security Groups

EC2

Elastic IP

Terraform

Terraform Modules

Terraform Remote State

Infrastructure as Code

Git

GitHub

Docker

CI/CD

AWS Networking

Cloud Security



---

💰 Cost Considerations

This is a personal learning project.

Potentially billable resources include:

EC2

NAT Gateway

Elastic IP

Application Load Balancer

CloudWatch


Resources should be destroyed when they are not required for testing.

terraform destroy

Always review the Terraform plan before destroying infrastructure.


---

📸 Screenshots

Planned screenshots:

[ ] VPC

[ ] Subnets

[ ] Route Tables

[ ] Internet Gateway

[ ] NAT Gateway

[ ] Security Groups

[ ] EC2

[ ] Private connectivity test

[ ] Terraform plan

[ ] GitHub Actions

[ ] Docker deployment

[ ] Load Balancer

[ ] CloudWatch



---

🎯 Final Goal

Build a production-like AWS infrastructure using Terraform, Docker and CI/CD.

The final project will demonstrate:

AWS
 +
Terraform
 +
Linux
 +
Docker
 +
CI/CD
 +
Networking
 +
Security
 +
High Availability
 +
Monitoring


---

👨‍💻 Author

Raouf Yahiaoui

DevOps / Cloud Portfolio

Focus:

AWS

Terraform

Linux

Docker

CI/CD

Cloud Infrastructure