terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.4"
    }
  }
}