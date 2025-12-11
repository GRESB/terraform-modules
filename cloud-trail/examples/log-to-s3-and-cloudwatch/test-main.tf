terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-cloudtrail-log-to-s3-and-cloudwatch"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "aws_cloudtrail" {
  source = "../../"

  create_cloudwatch_log_group = true
}

output "trail_cloudwatch_log_group_name" {
  value = module.aws_cloudtrail.trail_cloudwatch_log_group_name
}
