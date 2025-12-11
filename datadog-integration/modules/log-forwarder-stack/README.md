# Log Forwarder Stack

Provision a forwarder stack to send logs to Datadog.

This module requires that the function package be made available from an S3 bucket.
The packages can be downloaded from [DataDog's GitHub releases page](https://github.com/DataDog/datadog-serverless-functions/releases), then uploaded to an S3 bucket fom which the function implementation can be provisioned.

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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket_subscriptions"></a> [bucket\_subscriptions](#module\_bucket\_subscriptions) | ../log-forwarder-bucket-subscription | n/a |
| <a name="module_cloudwatch_event_subscriptions"></a> [cloudwatch\_event\_subscriptions](#module\_cloudwatch\_event\_subscriptions) | ../log-forwarder-cloudwatch-event-subscription | n/a |
| <a name="module_cloudwatch_log_group_subscriptions"></a> [cloudwatch\_log\_group\_subscriptions](#module\_cloudwatch\_log\_group\_subscriptions) | ../log-forwarder-cloudwatch-log-group-subscription | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.forwarder](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_iam_roles.forwarder_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_roles) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_datadog_api_key_secret_arn"></a> [datadog\_api\_key\_secret\_arn](#input\_datadog\_api\_key\_secret\_arn) | The ARN of a AWS SecretsManager secret containing the DD API key to be used in the forwarding stack | `string` | n/a | yes |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | The DD site to set as a parameter to the cloudFormation stack. Se valid options here https://docs.datadoghq.com/getting_started/site/ | `string` | `"datadoghq.eu"` | no |
| <a name="input_forwarder_bucket_subscriptions"></a> [forwarder\_bucket\_subscriptions](#input\_forwarder\_bucket\_subscriptions) | Map of bucket names to a pairs of bucket ARN and KMS key ARN. This map is used to configure forwarding logs from the respective bucekts to DD. | <pre>map(object({<br>    bucket_arn   = string<br>    is_encrypted = bool<br>    kms_key_arn  = string<br>  }))</pre> | `{}` | no |
| <a name="input_forwarder_cloudwatch_event_subscriptions"></a> [forwarder\_cloudwatch\_event\_subscriptions](#input\_forwarder\_cloudwatch\_event\_subscriptions) | Map of CloudWatch event subscriptions | <pre>map(object({<br>    source      = string<br>    detail_type = string<br>  }))</pre> | `{}` | no |
| <a name="input_forwarder_cloudwatch_log_group_subscriptions"></a> [forwarder\_cloudwatch\_log\_group\_subscriptions](#input\_forwarder\_cloudwatch\_log\_group\_subscriptions) | Map of CloudWatch log group subscriptions | <pre>map(object({<br>    log_group_name              = string<br>    subscription_filter_pattern = string<br>  }))</pre> | `{}` | no |
| <a name="input_forwarder_include_at_match"></a> [forwarder\_include\_at\_match](#input\_forwarder\_include\_at\_match) | Regex pattern on which to filter. if set to empty string, no filtering is applied | `string` | `""` | no |
| <a name="input_forwarder_use_vpc"></a> [forwarder\_use\_vpc](#input\_forwarder\_use\_vpc) | Whether to use VPC or not. | `bool` | `false` | no |
| <a name="input_forwarder_vpc_security_group_ids"></a> [forwarder\_vpc\_security\_group\_ids](#input\_forwarder\_vpc\_security\_group\_ids) | The VPC security group ids to use. Comma separated list. | `string` | `""` | no |
| <a name="input_forwarder_vpc_subnet_ids"></a> [forwarder\_vpc\_subnet\_ids](#input\_forwarder\_vpc\_subnet\_ids) | The VPC subnets to use. Comma separated list. | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for all resources that will take them | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags appended to all resources that will take them | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_forwarder_bucket_subscription_kms_keys"></a> [log\_forwarder\_bucket\_subscription\_kms\_keys](#output\_log\_forwarder\_bucket\_subscription\_kms\_keys) | n/a |
| <a name="output_log_forwarder_function_arn"></a> [log\_forwarder\_function\_arn](#output\_log\_forwarder\_function\_arn) | n/a |
| <a name="output_log_forwarder_function_name"></a> [log\_forwarder\_function\_name](#output\_log\_forwarder\_function\_name) | n/a |
| <a name="output_log_forwarder_iam_role_arn"></a> [log\_forwarder\_iam\_role\_arn](#output\_log\_forwarder\_iam\_role\_arn) | n/a |
| <a name="output_log_forwarder_iam_role_name"></a> [log\_forwarder\_iam\_role\_name](#output\_log\_forwarder\_iam\_role\_name) | n/a |
| <a name="output_log_forwarder_stack_id"></a> [log\_forwarder\_stack\_id](#output\_log\_forwarder\_stack\_id) | n/a |
| <a name="output_log_forwarder_stack_outputs"></a> [log\_forwarder\_stack\_outputs](#output\_log\_forwarder\_stack\_outputs) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
