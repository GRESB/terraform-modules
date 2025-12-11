terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-config-managed-rules-complete-with-cmk"
    }
  }
}

variable "aws_region" {
  default = "eu-west-1"
}

provider "aws" {
  region = var.aws_region
}

variable "bucket_name" {
  default = "oss-devex-tf-module-aws-config-managed-rules-complete-cmk"
}

module "aws_config" {
  source = "../../"

  create_bucket        = false
  bucket_name          = module.bucket.this_s3_bucket_id
  bucket_object_prefix = "config-test"
}

output "iam_password_check_policy" {
  value = module.aws_config.iam_password_check_policy
}

module "bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = var.bucket_name
  acl           = "log-delivery-write"
  force_destroy = true

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.bucket_cmk.key_arn
      }
    }
  }
}

module "bucket_cmk" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/kms-key.git?ref=v1.0.1"

  key_name        = var.bucket_name
  key_description = "CMK for S3 bucket ${var.bucket_name}"

  key_policy = [
    {
      principals = [
        {
          type = "Service", identifiers = ["config.amazonaws.com"]
        },
      ]

      effect    = "Allow"
      actions   = ["kms:GenerateDataKey*"]
      resources = ["*"]
      condition = []
    },
  ]
}
