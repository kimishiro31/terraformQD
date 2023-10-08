terraform {
  required_version = ">=1.5.7"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.19.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"

  ## Credenciais
  access_key = "X"
  secret_key = "Y"
}
