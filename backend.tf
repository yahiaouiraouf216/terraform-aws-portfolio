terraform {
  backend "s3" {
    bucket       = "terraform-aws-portfolio-tfstate-raouf"
    key          = "terraform-aws-portfolio/terraform.tfstate"
    region       = "ca-central-1"
    use_lockfile = true
  }
}
