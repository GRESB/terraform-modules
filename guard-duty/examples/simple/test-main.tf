terraform {
  backend "remote" {
    organization = "open-source-devex"
    workspaces {
      name = "terraform-modules-aws-guard-duty-simple"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}


variable "email" {
  default = "devex.bot@gmail.com"
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_caller_identity" "member" {}

module "aws_guard_duty_master" {
  source = "../../"

  project = "test"

  is_guardduty_master = true

  s3_bucket_force_destroy = true

  member_list = [{
    account_id   = data.aws_caller_identity.member.account_id
    member_email = var.email
    invite       = true
  }]
}

module "aws_guard_duty_member" {
  source = "../../"

  is_guardduty_member = true
  master_account_id   = module.aws_guard_duty_master.account_id
}
