terraform {
  required_version = "~> 1.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.61"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3"
    }
  }
}
