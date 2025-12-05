variable "aws_region" {
  default = "eu-west-1"
}

provider "aws" {
  region = var.aws_region
}

variable "bucket_name" {
  default = "terraform-state-backend-simple-example"
}

module "tf_backend" {
  source = "../../"

  bucket_name = var.bucket_name

  force_destroy = true
}

data "aws_caller_identity" "current" {}

output "s3_bucket_id" {
  value = module.tf_backend.s3_bucket_id
}

output "s3_bucket_arn" {
  value = module.tf_backend.s3_bucket_arn
}

output "s3_bucket_region" {
  value = module.tf_backend.s3_bucket_region
}

output "s3_bucket_kms_key_arn" {
  value = module.tf_backend.s3_bucket_kms_key_arn
}

output "s3_bucket_kms_key_id" {
  value = module.tf_backend.s3_bucket_kms_key_id
}

output "s3_bucket_lock_tables_name" {
  value = module.tf_backend.s3_bucket_lock_table_name
}

output "s3_bucket_lock_table_id" {
  value = module.tf_backend.s3_bucket_lock_table_id
}

output "remote_state_config" {
  value = module.tf_backend.remote_state_config
}
