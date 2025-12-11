locals {
  resource_name_prefix = var.name_prefix != "" ? var.name_prefix : "dd-integration"

  use_default_stack_template = var.custom_rds_stack_template == null

  function_arn  = lookup(aws_cloudformation_stack.rds.outputs, "DatadogRdsArn", "")
  function_name = try(reverse(split(":", local.function_arn))[0], "") # Get function name from ARN

  stack_template = local.use_default_stack_template ? templatefile("${path.module}/files/cloudformation-stack-template.yaml", {
    lambda_role_arn   = local.role_arn
    dd_api_secret_arn = var.datadog_api_key_secret_arn
    datadog_site      = var.datadog_site
    python_version    = var.custom_rds_stack_python_version
    code_s3_bucket    = var.code_s3_bucket
    code_s3_object    = var.code_s3_object
  }) : ""
}

resource "aws_cloudformation_stack" "rds" {
  name = "${local.resource_name_prefix}-datadog-rds-stack"

  parameters = merge({
    KMSKeyId = local.kms_key_id
    },
    var.use_vpc ? {
      DdUseVPC            = var.use_vpc
      VPCSecurityGroupIds = var.vpc_security_group_ids
      VPCSubnetIds        = var.vpc_subnet_ids
  } : {})

  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]

  template_body = local.use_default_stack_template ? local.stack_template : var.custom_rds_stack_template

  tags = var.tags
}
