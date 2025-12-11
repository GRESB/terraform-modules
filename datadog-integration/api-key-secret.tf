locals {
  datadog_api_key_secret_arn = var.create_datadog_api_key_secret ? join("", aws_secretsmanager_secret.datadog_credentials[*].arn) : join("", data.aws_secretsmanager_secret.datadog_api_key_secret[*].arn)

  datadog_api_secret_name = "${local.resource_name_prefix}-datadog-api-key-${join("", random_string.datadog_credentials[*].result)}"
}

resource "aws_secretsmanager_secret" "datadog_credentials" {
  count = var.create_datadog_api_key_secret ? 1 : 0

  name = local.datadog_api_secret_name
}

resource "aws_secretsmanager_secret_version" "datadog_credentials" {
  count = var.create_datadog_api_key_secret ? 1 : 0

  secret_id     = join("", aws_secretsmanager_secret.datadog_credentials[*].id)
  secret_string = var.datadog_api_key
}

data "aws_secretsmanager_secret" "datadog_api_key_secret" {
  count = !var.create_datadog_api_key_secret ? 1 : 0

  arn = var.datadog_api_key_secret_arn
}

resource "random_string" "datadog_credentials" {
  count = var.create_datadog_api_key_secret ? 1 : 0

  # Only these symbols are allowed in the name of a aws_secretsmanager_secret
  override_special = "/_+=.@-"

  length = 6
}
