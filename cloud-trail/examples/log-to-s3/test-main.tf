terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-cloudtrail-log-to-s3"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "aws_cloudtrail" {
  source = "../../"

  create_s3_bucket        = true
  s3_bucket_name          = "oss-devex-tf-module-aws-cloudtrail-log-to-s3-test"
  s3_bucket_object_prefix = "config-test"
  s3_bucket_force_destroy = true
}

output "trail_name" {
  value = module.aws_cloudtrail.trail_name
}

output "trail_s3_bucket" {
  value = module.aws_cloudtrail.trail_s3_bucket
}
