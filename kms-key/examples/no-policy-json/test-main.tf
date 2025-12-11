terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-route53-query-log-complete"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "current" {}


module "kms_key" {
  source = "../../"

  key_policy = [
    {
      principals = [
        {
          type = "AWS", identifiers = [data.aws_caller_identity.current.arn]
        },
        {
          type = "Service", identifiers = ["cloudtrail.amazonaws.com"]
        },
      ]

      effect = "Allow"

      actions = ["kms:GenerateDataKey*"]

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


output "key_arn" {
  value = module.kms_key.key_arn
}

output "key_alias_name" {
  value = module.kms_key.key_alias_name
}

output "key_alias_arn" {
  value = module.kms_key.key_alias_arn
}
