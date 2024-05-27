terraform {
  cloud {
    organization = "Elchibek"

    workspaces {
      name = "aws-lambda-file-upload"
    }
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.env
      Project     = "aws-lambda-file-upload"
      Team        = "DevOps"
      ManagedBy   = "Terraform"
    }
  }
}