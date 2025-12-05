locals {
  dynamodb_table_arn  = join("", aws_dynamodb_table.tf_backend.*.arn)
  dynamodb_table_name = join("", aws_dynamodb_table.tf_backend.*.name)
  dynamodb_table_id   = join("", aws_dynamodb_table.tf_backend.*.id)
}

resource "aws_dynamodb_table" "tf_backend" {
  count = var.create_dynamo_lock_table ? 1 : 0

  name           = var.bucket_name
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = module.cmk.key_arn
  }

  tags = merge(var.common_tags, {
    Name = "Terraform backend lock table for ${var.bucket_name} S3 bucket"
  })
}
