terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-config-managed-rules-simple"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "aws_config" {
  source = "../../"

  create_bucket        = true
  bucket_name          = "oss-devex-tf-module-aws-config-managed-rules-test"
  bucket_object_prefix = "config-test"
  bucket_force_destroy = true
}

output "iam_password_check_policy" {
  value = module.aws_config.iam_password_check_policy
}
