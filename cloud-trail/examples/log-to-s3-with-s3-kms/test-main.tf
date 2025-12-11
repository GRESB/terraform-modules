terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-cloudtrail-log-to-s3-with-s3-kms"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

variable "bucket_name" {
  default = "oss-devex-tf-module-aws-cloudtrail-log-to-s3-with-s3-kms-test"
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
        sse_algorithm     = "AES256"
        kms_master_key_id = ""
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
