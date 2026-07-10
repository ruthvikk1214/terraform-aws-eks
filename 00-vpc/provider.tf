terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.39.0"
    }
  }
  backend "s3" {
  bucket = "remote-state-roboshop-dev-rk1214"
  key    = "terraform-aws-eks/vpc"
  region = "us-east-1"

  encrypt     = true
  use_lockfile = true
}
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

}