locals {
  create_s3_bucket = var.enabled && var.create_s3_bucket
}

resource "aws_s3_bucket" "trail_bucket" {
  count = local.create_s3_bucket ? 1 : 0

  bucket = local.trail_bucket_name

  force_destroy = var.s3_bucket_force_destroy

  policy = join("", data.aws_iam_policy_document.trail_bucket.*.json)

  tags = var.tags
}

# https://docs.aws.amazon.com/awscloudtrail/latest/userguide/create-s3-bucket-policy-for-cloudtrail.html
data "aws_iam_policy_document" "trail_bucket" {
  count = local.create_s3_bucket ? 1 : 0

  statement {
    sid = "AWSCloudTrailAclCheck"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.trail_bucket_name}"]
  }

  statement {
    sid = "AWSCloudTrailWrite"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }

    effect  = "Allow"
    actions = ["s3:PutObject"]
    resources = [
      "arn:aws:s3:::${local.trail_bucket_name}/${var.s3_bucket_object_prefix != "" ? format("%s/", var.s3_bucket_object_prefix) : ""}AWSLogs/${data.aws_caller_identity.current.account_id}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"

      values = ["bucket-owner-full-control"]
    }
  }
}


resource "aws_s3_bucket_public_access_block" "config_bucket" {
  count = local.create_s3_bucket && var.s3_bucket_block_public_access ? 1 : 0

  bucket = join("", aws_s3_bucket.trail_bucket.*.id)

  block_public_acls   = true
  block_public_policy = true
}
