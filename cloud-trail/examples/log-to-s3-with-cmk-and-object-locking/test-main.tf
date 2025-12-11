terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-cloudtrail-log-to-s3-with-cmk-and-object-locking"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

variable "bucket_name" {
  default = "oss-devex-tf-module-aws-cloudtrail-s3-with-cmk-and-objlock-test"
}

variable "bucket_object_prefix" {
  default = "config-test"
}

module "aws_cloudtrail" {
  source = "../../"

  create_s3_bucket        = false
  s3_bucket_name          = module.bucket.this_s3_bucket_id
  s3_bucket_object_prefix = var.bucket_object_prefix
}

output "trail_name" {
  value = module.aws_cloudtrail.trail_name
}

output "trail_s3_bucket" {
  value = module.aws_cloudtrail.trail_s3_bucket
}

module "bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket        = var.bucket_name
  acl           = "log-delivery-write"
  force_destroy = true

  policy = data.aws_iam_policy_document.trail_bucket.json

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

  object_lock_configuration = {
    object_lock_enabled = "Enabled"
    rule                = {
      default_retention = {
        mode = "GOVERNANCE"
        days = 1
      }
    }
  }
}

data "aws_iam_policy_document" "trail_bucket" {
  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/${var.bucket_object_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = ["bucket-owner-full-control"]
    }
  }
}

data "aws_caller_identity" "current" {}

# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-kms-key-policy-for-cloudtrail.html
module "bucket_cmk" {
  source = "git::https://gitlab.com/open-source-devex/terraform-modules/aws/kms-key.git?ref=v1.0.1"

  key_name        = var.bucket_name
  key_description = "CMK for S3 bucket ${var.bucket_name}"

  key_policy = [
    {
      principals = [
        {
          type        = "Service",
          identifiers = ["cloudtrail.amazonaws.com"]
        },
      ]

      effect    = "Allow"
      actions   = ["kms:GenerateDataKey*"]
      resources = ["*"]

      condition = [
        {
          test     = "StringLike"
          variable = "kms:EncryptionContext:aws:cloudtrail:arn"
          values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
        }
      ]
    },
  ]
}
