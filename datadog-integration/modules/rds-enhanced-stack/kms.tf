locals {
  kms_key_id = module.rds_cmk.key_id

  aws_account_id = data.aws_caller_identity.current.account_id

  # The next block of locals is meant to detect if the identity used for the provider is an assumed role,
  # and if it is discover the ARN of that role to use in the KMS policy.
  current_identity                  = data.aws_caller_identity.current.arn
  assumed_role_sub_string           = "${local.aws_account_id}:assumed-role/"
  provider_identity_is_assumed_role = contains(regex("^(?:.*(${local.assumed_role_sub_string}))?.*$", local.current_identity), local.assumed_role_sub_string) # test contains string
  assumed_role_name                 = local.provider_identity_is_assumed_role ? try(regex("^.*${local.assumed_role_sub_string}(.*)/.*$", local.current_identity)[0], "") : ""
  provider_identity                 = local.provider_identity_is_assumed_role ? join(",", data.aws_iam_role.assumed[*].arn) : local.current_identity

  default_kms_policy = [
    # Allow all roles to use the key for decrypting DD api key if coming via lambda
    {
      effect = "Allow"
      principals = [{
        type        = "AWS"
        identifiers = ["*"]
      }]
      actions = [ "kms:Decrypt" ]
      resources = ["*"]

      condition = [{
        test     = "StringEquals"
        variable = "kms:ViaService"
        values   = ["lambda.eu-central-1.amazonaws.com"]
      }]
    },
    {
      # Allow lambda execution role to use the key for decrypting DD api key
      principals = [{
        type = "AWS", identifiers = [local.role_arn]
      }]

      effect    = "Allow"
      actions   = ["kms:Decrypt"]
      resources = ["*"]
      condition = []
    },
    {
      # Allow us (the identity behind the provider) to encrypt the api keys for the stack
      principals = [{
        type = "AWS", identifiers = [local.provider_identity]
      }]

      effect    = "Allow"
      actions   = ["kms:Encrypt"]
      resources = ["*"]
      condition = []
    }
  ]

  kms_key_policy = concat(local.default_kms_policy, var.custom_rds_stack_kms_key_policy)
}

module "rds_cmk" {
  source = "git::https://github.com/GRESB/terraform-modules.git//kms-key?ref=v0.5.0"

  key_name        = "${local.resource_name_prefix}-datadog-rds-stack"
  key_description = "CMK for DD RDS Enhanced Stack ${local.resource_name_prefix}"
  tags            = var.tags

  key_policy = local.kms_key_policy
}

data "aws_caller_identity" "current" {}

data "aws_iam_role" "assumed" {
  count = local.provider_identity_is_assumed_role ? 1 : 0

  name = local.assumed_role_name
}
