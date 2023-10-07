terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }

  backend "s3" {
    bucket         = "tally-tool-terraform"
    key            = "network/terraform.tfstate"
    dynamodb_table = "tally-tool-terraform"
    region         = "eu-west-3"
  }
}

provider "aws" {}
