#####################################################################################################
# This example requires two applies, one to create the user and role and a second to create the rest
#     terraform apply -auto-approve -target aws_iam_user.test_user \
#                                   -target aws_iam_user.test_user_path_based \
#                                   -target aws_iam_role.test_role \
#                                   -target aws_iam_role.test_role_path_based
#     terraform apply -auto-approve
#####################################################################################################

variable "aws_region" {
  default = "eu-west-1"
}

provider "aws" {
  region = var.aws_region
}

variable "bucket_name" {
  default = "terraform-state-backend-complete-example"
}

module "tf_backend" {
  source = "../../"

  bucket_name = var.bucket_name
  bucket_acl  = "private"

  generate_remote_state_config_file = true

  force_destroy = true

  create_dynamo_lock_table = true

  common_tags = {
    foo = "bar"
  }

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true

  prevent_unencrypted_uploads = true

  kms_deletion_window = 7

  users = [aws_iam_user.test_user.arn]
  roles = [aws_iam_role.test_role.arn]

  path_based_permissions = {
    user_rw = {
      principal_type = "user"
      principal_name = aws_iam_user.test_user_path_based.name
      paths          = ["development/*"]
      action         = "read-write"
    }
    user_ro = {
      principal_type = "user"
      principal_name = aws_iam_user.test_user_path_based.name
      paths          = ["production/*"]
      action         = "read"
    }
    developer_rw = {
      principal_type = "role"
      principal_name = aws_iam_role.test_role_path_based.name
      paths          = ["development/*"]
      action         = "read-write"
    }
    developer_ro = {
      principal_type = "role"
      principal_name = aws_iam_role.test_role_path_based.name
      paths          = ["production/*"]
      action         = "read"
    }
  }
}

resource "aws_iam_user" "test_user" {
  name = "${var.bucket_name}-test-user"
}

resource "aws_iam_user" "test_user_path_based" {
  name = "${var.bucket_name}-test-user-path-based"
}

resource "aws_iam_role" "test_role" {
  name               = "${var.bucket_name}-test-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${data.aws_caller_identity.current.account_id}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "test_role_path_based" {
  name               = "${var.bucket_name}-test-role-path-based"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${data.aws_caller_identity.current.account_id}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
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
