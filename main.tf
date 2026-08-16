resource "aws_s3_bucket" "tfstate" {
  bucket = "terraform-aws-portfolio-tfstate-raouf"
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name        = "terraform-aws-portfolio-tfstate-raouf"
    Environment = "Dev"
    Purpose     = "Terraform state storage"
  }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket                  = aws_s3_bucket.tfstate.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "networking" {
  source   = "./modules/networking"
  vpc_cidr = "10.0.0.0/16"
}

module "security" {
  source     = "./modules/security"
  vpc_id     = module.networking.vpc_id
  admin_cidr = var.admin_cidr
}

module "compute" {
  source            = "./modules/compute"
  subnet_id         = module.networking.public_subnet_a_id
  security_group_id = module.security.security_group_id
  private_subnet_id = module.networking.private_subnet_a_id
}