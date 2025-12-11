locals {
  cmk_name = replace(var.bucket_name, ".", "-")

  allowed_arns_for_cmk = flatten([
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
    var.users,
    var.roles,
  ])

  cmk_key_arn        = module.cmk.key_arn
  cmk_key_id         = module.cmk.key_id
  cmk_key_alias_name = module.cmk.key_alias_name
  cmk_key_alias_arn  = module.cmk.key_alias_arn
}

module "cmk" {
  source = "git::https://github.com/GRESB/terraform-modules.git//kms-key?ref=v0.5.0"

  key_name                    = local.cmk_name
  key_description             = "CMK for S3 bucket ${var.bucket_name}"
  deletion_window_in_days     = var.kms_deletion_window
  allow_account_to_manage_key = var.allow_account_to_manage_kms_key

  tags = merge(var.common_tags, {
    Name = "${var.bucket_name} S3 Bucket CMK"
  })

  key_policy = [
    {
      principals = [{
        type = "AWS", identifiers = local.allowed_arns_for_cmk
      }]

      effect = "Allow"

      actions = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey",
      ]

      resources = ["*"]
      condition = []
    },
  ]
}
