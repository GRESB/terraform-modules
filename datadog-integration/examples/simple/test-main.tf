terraform {
  required_version = "~> 1.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    datadog = {
      source  = "datadog/datadog"
      version = "~> 3.16"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

variable "datadog_api_key" { type = string }
variable "datadog_app_key" { type = string }

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = "https://api.datadoghq.eu/"
}

module "datadog_integration" {
  source = "../../"

  datadog_api_key = var.datadog_api_key

  enable_datadog_forwarder_stack = true
  enable_datadog_rds_stack       = true

  filter_tags = {}

  tags = {
    dd-integration-test = "dd-integration-test"
  }
}
