terraform {
  required_version = "~> 1.9.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }
  }
}

// Configure the AWS Provider
provider "aws" {
  region  = "ap-northeast-1"
  profile = "yoshii-apphandson"


  default_tags {
    tags = {
      Env = "opsjaws_handson"
    }
  }
}
