terraform {
  required_version = ">= 1.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 1.5"
    }
  }
}
