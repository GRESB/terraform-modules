locals {
  resource_name_prefix = var.name_prefix != "" ? var.name_prefix : "dd-integration"
  resource_name        = "${local.resource_name_prefix}-datadog-forwarder"

  tags = join(",", formatlist("%s:%s", keys(var.tags), values(var.tags)))

  function_arn  = lookup(aws_cloudformation_stack.forwarder.outputs, "DatadogForwarderArn", "")
  function_name = try(reverse(split(":", local.function_arn))[0], "") # Get function name from ARN

  forwarder_iam_role_name = try(tolist(data.aws_iam_roles.forwarder_role.names)[0], "NA")
  forwarder_iam_role_arn  = try(tolist(data.aws_iam_roles.forwarder_role.arns)[0], "NA")
}

resource "aws_cloudformation_stack" "forwarder" {
  name         = local.resource_name
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = merge({
    DdApiKeySecretArn = var.datadog_api_key_secret_arn
    DdSite            = var.datadog_site
    IncludeAtMatch    = var.forwarder_include_at_match
    FunctionName      = local.resource_name
    DdTags            = local.tags
    }, var.forwarder_use_vpc ? {
    DdUseVPC            = var.forwarder_use_vpc
    VPCSecurityGroupIds = var.forwarder_vpc_security_group_ids
    VPCSubnetIds        = var.forwarder_vpc_subnet_ids
  } : {})

  # needs to updated every time until this is fixed https://github.com/hashicorp/terraform-provider-aws/issues/13930
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/latest.yaml"

  tags = var.tags
}

data "aws_iam_roles" "forwarder_role" {
  name_regex = "${local.resource_name}-ForwarderRole-.*"

  depends_on = [aws_cloudformation_stack.forwarder]
}
