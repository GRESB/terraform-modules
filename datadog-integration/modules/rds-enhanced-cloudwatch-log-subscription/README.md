# RDS Enhanced CloudWatch Log Subscription

Provision a subscription for CloudWatch logs to enable enhanced monitoring.

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.33 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_subscription_filter.log_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_lambda_permission.log_subscription](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_cloudwatch_log_group.rds_os_metrics](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudwatch_log_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the CloudWatch log group for RDS OS metrics | `string` | `"RDSOSMetrics"` | no |
| <a name="input_cloudwatch_subscription_distribution"></a> [cloudwatch\_subscription\_distribution](#input\_cloudwatch\_subscription\_distribution) | The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are "Random" and "ByLogStream". | `string` | `"Random"` | no |
| <a name="input_cloudwatch_subscription_filter_pattern"></a> [cloudwatch\_subscription\_filter\_pattern](#input\_cloudwatch\_subscription\_filter\_pattern) | A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. | `string` | `""` | no |
| <a name="input_datadog_rds_function_arn"></a> [datadog\_rds\_function\_arn](#input\_datadog\_rds\_function\_arn) | The ARN of the DD forwarder stack lambda | `string` | n/a | yes |
| <a name="input_datadog_rds_function_name"></a> [datadog\_rds\_function\_name](#input\_datadog\_rds\_function\_name) | The name of the DD forwarder stack lambda | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for all resources that will take them | `string` | `""` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | The name of the subscription. | `string` | `null` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
