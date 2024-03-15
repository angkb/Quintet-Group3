terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "cf-s3" {
  source      = "./modules/cloudfront-s3"
}
