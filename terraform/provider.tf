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
  # profile = "xxxxxxxxx"     # 必要に応じて任意のプロファイル名を設定してください 


  default_tags {
    tags = {
      Env = "opsjaws_handson"
    }
  }
}
