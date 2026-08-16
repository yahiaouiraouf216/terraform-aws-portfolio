# Terraform AWS DevOps Portfolio

Infrastructure as Code project built with **Terraform on AWS**.

The goal of this project is to progressively build a professional, production-inspired AWS infrastructure while demonstrating practical skills in:

* AWS
* Terraform
* Linux
* Networking
* Security
* Docker
* CI/CD
* High Availability
* Monitoring

---

# 📌 Project Status

🚧 **In Progress**

The Terraform configuration is modularized and uses a remote S3 backend.

The current infrastructure configuration includes a VPC with public and private subnets, security controls, EC2 instances, and a cost-conscious network design.

NAT Gateways are currently **disabled by default** to avoid unnecessary AWS costs.

---

# 🏗️ Architecture

## Current Terraform Architecture

```text
                         Internet
                            |
                     Internet Gateway
                            |
                  +---------+---------+
                  |                   |
               Public A            Public B
            10.0.1.0/24          10.0.3.0/24
                  |                   |
                  |                   |
              EC2 Web            Available
            Public subnet         public subnet
                  |
                  |
                 VPC
            10.0.0.0/16
             /          \
            /            \
     Private A          Private B
    10.0.2.0/24        10.0.4.0/24
```

### Network

**VPC**

* CIDR: `10.0.0.0/16`
* Region: `ca-central-1`

**Availability Zones**

* `ca-central-1a`
* `ca-central-1b`

**Public Subnets**

| Subnet   | CIDR          | Availability Zone |
| -------- | ------------- | ----------------- |
| Public A | `10.0.1.0/24` | `ca-central-1a`   |
| Public B | `10.0.3.0/24` | `ca-central-1b`   |

**Private Subnets**

| Subnet    | CIDR          | Availability Zone |
| --------- | ------------- | ----------------- |
| Private A | `10.0.2.0/24` | `ca-central-1a`   |
| Private B | `10.0.4.0/24` | `ca-central-1b`   |

---

# ☁️ AWS Services

## Implemented in Terraform

* Amazon VPC
* Amazon EC2
* Amazon S3
* Internet Gateway
* Route Tables
* Security Groups
* IAM Role
* IAM Instance Profile
* AWS Systems Manager integration
* Terraform remote state

## Planned

* NAT Gateway
* Application Load Balancer
* Auto Scaling
* CloudWatch
* Docker
* GitHub Actions CI/CD

---

# 🌐 Networking

The networking infrastructure is implemented as a reusable Terraform module.

The VPC contains two Availability Zones with public and private subnets.

### Public routing

Public subnets use an Internet Gateway for Internet access.

```text
Public Subnet
      |
      v
Public Route Table
      |
      v
Internet Gateway
      |
      v
Internet
```

### Private routing

Private subnets currently do **not** have a NAT Gateway.

NAT Gateway creation is controlled by:

```hcl
enable_nat_gateway = false
```

This prevents unnecessary NAT Gateway costs during development.

The Terraform module can enable NAT Gateways later when private Internet connectivity is required.

---

# 🔐 Security

## SSH

SSH access is restricted to the administrator CIDR.

```text
TCP 22
Source: ADMIN_CIDR/32
```

The project intentionally avoids:

```text
0.0.0.0/0 → TCP 22
```

## HTTP

HTTP access is allowed for the web workload:

```text
TCP 80
Source: 0.0.0.0/0
```

## EC2 Security

The security module manages:

* SSH ingress
* HTTP ingress
* Egress traffic

The private EC2 configuration does not assign a public IP address.

---

# 💾 Terraform Remote State

Terraform state is stored remotely in Amazon S3.

**Bucket**

```text
terraform-aws-portfolio-tfstate-raouf
```

**Key**

```text
terraform-aws-portfolio/terraform.tfstate
```

**Region**

```text
ca-central-1
```

The S3 backend uses:

* Server-side encryption
* Versioning
* Public access blocking
* Terraform state locking with the S3 backend lock file mechanism

Remote state allows Terraform state to be separated from the local project directory.

---

# 📁 Project Structure

```text
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
```

---

# 🧩 Terraform Modules

## Networking Module

Responsible for:

* VPC
* Public subnets
* Private subnets
* Internet Gateway
* Public Route Table
* Private Route Tables
* Route Table Associations
* Optional NAT Gateway configuration

## Security Module

Responsible for:

* EC2 Security Group
* SSH ingress
* HTTP ingress
* Egress rules

## Compute Module

Responsible for:

* Amazon Linux AMI lookup
* EC2 instances
* IAM Role
* IAM Instance Profile
* EC2 networking
* Systems Manager access
* EC2 outputs

---

# 🖥️ Compute

The project contains a public web EC2 instance managed by Terraform.

Current instance type:

```text
t3.micro
```

The project also contains Terraform configuration for a private EC2 instance.

The private instance is configured with:

```text
Public IP: disabled
Subnet: Private A
Instance type: t3.micro
```

The private EC2 resource is currently part of the Terraform configuration and plan. It should not be considered deployed until `terraform apply` is executed.

---

# 🔄 Private EC2 Traffic Flow

The intended private architecture is:

```text
Private EC2
     |
     v
Private Route Table
     |
     v
NAT Gateway (optional)
     |
     v
Internet Gateway
     |
     v
Internet
```

NAT Gateway functionality is currently disabled to avoid unnecessary costs.

When enabled, the NAT Gateway will provide outbound Internet connectivity to private resources without assigning public IP addresses to those resources.

---

# 🧪 Terraform Validation

The project is validated using:

```bash
terraform fmt -recursive
```

Formats Terraform configuration files.

```bash
terraform validate
```

Validates the Terraform configuration.

```bash
terraform plan
```

Shows the infrastructure changes Terraform would perform without applying them.

The project is developed with a **plan-first workflow** to review infrastructure changes before deployment.

---

# 🔀 Git Workflow

Check repository status:

```bash
git status
```

Stage changes:

```bash
git add .
```

Commit changes:

```bash
git commit -m "feat: description"
```

Push to GitHub:

```bash
git push origin main
```

---

# 🚀 Roadmap

## Phase 1 — Terraform Foundation

* [x] Terraform initialization
* [x] AWS provider
* [x] Variables
* [x] Outputs
* [x] Terraform modules
* [x] Git/GitHub

## Phase 2 — Remote State

* [x] S3 backend
* [x] Server-side encryption
* [x] Versioning
* [x] Public access block
* [x] State locking

## Phase 3 — Networking

* [x] VPC
* [x] Public subnet A
* [x] Public subnet B
* [x] Private subnet A
* [x] Private subnet B
* [x] Internet Gateway
* [x] Public Route Table
* [x] Private Route Tables
* [x] Multi-AZ network design
* [x] Optional NAT Gateway configuration
* [ ] Deploy NAT Gateway when required

## Phase 4 — Security

* [x] Security Group
* [x] SSH restriction
* [x] HTTP rule
* [x] Egress rule
* [x] IAM role for EC2
* [x] Systems Manager access
* [ ] Final private EC2 security validation

## Phase 5 — Compute

* [x] EC2 module
* [x] Amazon Linux AMI lookup
* [x] Public EC2 configuration
* [x] EC2 outputs
* [x] Private EC2 configuration
* [ ] Deploy private EC2
* [ ] Validate private connectivity

## Phase 6 — Docker

* [ ] Application
* [ ] Dockerfile
* [ ] Docker image
* [ ] Container deployment

## Phase 7 — CI/CD

* [ ] GitHub Actions
* [ ] Terraform validation
* [ ] Docker build
* [ ] Automated deployment

## Phase 8 — High Availability

* [ ] Application Load Balancer
* [ ] Target Groups
* [ ] Auto Scaling Group
* [ ] Multi-AZ application deployment

## Phase 9 — Monitoring

* [ ] CloudWatch
* [ ] VPC Flow Logs

## Phase 10 — Documentation

* [ ] Architecture diagram
* [ ] AWS screenshots
* [ ] Validation results
* [ ] Final documentation

---

# 🧠 Skills Demonstrated

* AWS
* Amazon VPC
* IPv4 CIDR planning
* Public and private subnet design
* Availability Zones
* Internet Gateway
* Route Tables
* NAT Gateway architecture
* Security Groups
* IAM
* EC2
* Amazon S3
* Terraform
* Terraform Modules
* Terraform Remote State
* Infrastructure as Code
* Git
* GitHub
* Linux

---

# 💰 Cost Considerations

This is a personal learning and portfolio project.

Potentially billable AWS resources include:

* EC2
* NAT Gateway
* Elastic IP
* Application Load Balancer
* CloudWatch

NAT Gateways are intentionally disabled by default in the current Terraform configuration to avoid unnecessary costs.

Before deploying infrastructure:

```bash
terraform plan
```

should always be reviewed.

When infrastructure is no longer required, resources can be removed with:

```bash
terraform destroy
```

A Terraform plan should always be reviewed before confirming a destructive operation.

---

# 📸 Screenshots

Planned documentation screenshots:

* [ ] VPC
* [ ] Subnets
* [ ] Route Tables
* [ ] Internet Gateway
* [ ] Security Groups
* [ ] EC2
* [ ] Terraform plan
* [ ] GitHub repository
* [ ] GitHub Actions
* [ ] Docker deployment
* [ ] Load Balancer
* [ ] CloudWatch

---

# 🎯 Final Goal

Build a production-inspired AWS infrastructure using Terraform, Docker and CI/CD.

The final portfolio will demonstrate:

```text
AWS
 +
Terraform
 +
Linux
 +
Networking
 +
Security
 +
Docker
 +
CI/CD
 +
High Availability
 +
Monitoring
```

---

# 👨‍💻 Author

**Raouf Yahiaoui**

DevOps / Cloud Portfolio

Focus:

* AWS
* Terraform
* Linux
* Docker
* CI/CD
* Cloud Infrastructure
