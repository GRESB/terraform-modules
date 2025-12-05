locals {
  s3_bucket_id     = module.s3_bucket.s3_bucket_id
  s3_bucket_arn    = module.s3_bucket.s3_bucket_arn
  s3_bucket_region = module.s3_bucket.s3_bucket_region
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.2"

  bucket = var.bucket_name
  acl    = var.bucket_acl

  attach_policy = var.bucket_policy != ""
  policy        = var.bucket_policy
  

  force_destroy = var.force_destroy

  tags = merge(var.common_tags, {
    Name = var.bucket_name
  })

  versioning = {
    enabled = true
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = module.cmk.key_alias_arn
      }
    }
  }

  block_public_acls       = var.block_public_acls
  ignore_public_acls      = var.ignore_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets

  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = true

  attach_deny_unencrypted_object_uploads   = var.prevent_unencrypted_uploads
}
