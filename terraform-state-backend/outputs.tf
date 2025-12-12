output "aws_iam_policy_name" {
  value = aws_iam_policy.tf_backend.name
}

output "aws_iam_policy_arn" {
  value = aws_iam_policy.tf_backend.arn
}

output "s3_bucket_id" {
  value = local.s3_bucket_id
}

output "s3_bucket_arn" {
  value = local.s3_bucket_arn
}

output "s3_bucket_region" {
  value = local.s3_bucket_region
}

output "s3_bucket_kms_key_arn" {
  value = local.cmk_key_arn
}

output "s3_bucket_kms_key_alias_arn" {
  value = local.cmk_key_alias_arn
}

output "s3_bucket_kms_key_id" {
  value = local.cmk_key_id
}

output "s3_bucket_kms_key_alias_name" {
  value = local.cmk_key_alias_name
}

output "s3_bucket_lock_table_name" {
  value = local.dynamodb_table_name
}

output "s3_bucket_lock_table_id" {
  value = local.dynamodb_table_id
}

output "remote_state_config" {
  value = <<EOV

backend = "s3"
config  = {
  bucket         = "${module.s3_bucket.s3_bucket_id}"
  # in terragrunt projects this key is best prefixed with the path to the module to avoid overwriting it
  # like:  key = "$${path_relative_to_include()}/terraform.tfstate"
  key            = "terraform.tfstate"
  region         = "${data.aws_region.current.region}"
  encrypt        = true
  # Omit dynamo DB if locking is disabled
  dynamodb_table = "${join("", aws_dynamodb_table.tf_backend.*.name)}"
}

EOV
}

resource "local_file" "generate_remote_state_config_file" {
  count = var.generate_remote_state_config_file ? 1 : 0

  filename        = var.remote_state_config_file_path
  file_permission = "0600"

  content = yamlencode({
    region         = data.aws_region.current.region
    bucket         = module.s3_bucket.s3_bucket_id
    dynamodb_table = module.s3_bucket.s3_bucket_id
    encrypt        = true
  })

  depends_on = [null_resource.create_remote_state_config_path]
}

resource "null_resource" "create_remote_state_config_path" {
  count = var.generate_remote_state_config_file ? 1 : 0

  provisioner "local-exec" {
    command = "mkdir -p ${dirname(var.remote_state_config_file_path)}"
  }

  triggers = {
    path = dirname(var.remote_state_config_file_path)
  }
}
