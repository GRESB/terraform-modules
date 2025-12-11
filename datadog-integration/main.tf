resource "datadog_integration_aws_external_id" "integration" {}

resource "datadog_integration_aws_account" "integration" {
  account_tags   = var.aws_account_tags
  aws_account_id = var.aws_account_id
  aws_partition  = "aws"
  auth_config {
    aws_auth_config_role {
      role_name = "${local.resource_name_prefix}-datadog-integration-role"
    }
  }
  aws_regions {
    include_all  = var.regions == null ? true : null
    include_only = var.regions
  }

  logs_config {
    lambda_forwarder {
      lambdas = var.logs_forwarder_lambdas
      sources = var.logs_forwarder_sources
    }
  }
  metrics_config {
    automute_enabled          = var.automute_enabled  
    enabled                   = var.metrics_config_enabled
    collect_cloudwatch_alarms = var.collect_cloudwatch_alarms
    collect_custom_metrics    = var.collect_custom_metrics
    namespace_filters {
      include_only = var.namespace_include_only
    }
    dynamic "tag_filters" {
      for_each = var.tag_filters
      content {
        namespace = tag_filters.value.namespace
        tags      = tag_filters.value.tags
      }
    }
  }
  resources_config {
    cloud_security_posture_management_collection = var.cloud_security_posture_management_collection
    extended_collection                          = var.extended_collection 
  }
  traces_config {
    xray_services {
      include_all  = var.xray_services == null ? true : null
      include_only = var.xray_services
    }
  }
}
