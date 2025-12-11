locals {
  resource_name_prefix = var.name_prefix != "" ? var.name_prefix : "dd-integration"

  aws_account_id = var.aws_account_id != null ? var.aws_account_id : join("", data.aws_caller_identity.current[*].account_id)
}

data "aws_caller_identity" "current" {
}
