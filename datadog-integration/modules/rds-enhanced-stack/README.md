# RDS Enhanced Monitoring Stack

This module setups the DD RDS Enhanced Monitoring Stack.
For this stack a lambda is used and that usually is obtained from a DD S3 bucket.
however, the key for the object keeps changing and that breaks the module.
To that end, the module expects a S3 bucket and a S3 object as input.
The module contains an AWS SAM template adapted form the original.

The source for both the SAM template and the lambda function code is this repo https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/rds_enhanced_monitoring.
Please upload the lambda zip to a S3 bucket and wire those parameters in the module.

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
| <a name="module_rds_cmk"></a> [rds\_cmk](#module\_rds\_cmk) | git::https://gitlab.com/open-source-devex/terraform-modules/aws/kms-key.git | v2.0.1 |
| <a name="module_subscription"></a> [subscription](#module\_subscription) | ../rds-enhanced-cloudwatch-log-subscription | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack.rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack) | resource |
| [aws_iam_policy.rds_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.rds_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.rds_lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.rds_lambda_generic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.rds_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.assumed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cloudwatch_log_group_name"></a> [cloudwatch\_log\_group\_name](#input\_cloudwatch\_log\_group\_name) | The name of the CloudWatch log group for RDS OS metrics | `string` | `"RDSOSMetrics"` | no |
| <a name="input_cloudwatch_subscription_distribution"></a> [cloudwatch\_subscription\_distribution](#input\_cloudwatch\_subscription\_distribution) | The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are "Random" and "ByLogStream". | `string` | `"Random"` | no |
| <a name="input_cloudwatch_subscription_filter_pattern"></a> [cloudwatch\_subscription\_filter\_pattern](#input\_cloudwatch\_subscription\_filter\_pattern) | A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. | `string` | `""` | no |
| <a name="input_code_s3_bucket"></a> [code\_s3\_bucket](#input\_code\_s3\_bucket) | The bucket where the lambda function package can be found | `string` | n/a | yes |
| <a name="input_code_s3_object"></a> [code\_s3\_object](#input\_code\_s3\_object) | The bucket object with the lambda function. Source https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/rds_enhanced_monitoring | `string` | n/a | yes |
| <a name="input_configure_rds_subscription"></a> [configure\_rds\_subscription](#input\_configure\_rds\_subscription) | Whether to enable the CloudWatch log subscription and ship logs to DD | `bool` | `true` | no |
| <a name="input_custom_rds_stack_kms_key_policy"></a> [custom\_rds\_stack\_kms\_key\_policy](#input\_custom\_rds\_stack\_kms\_key\_policy) | A addition KMS Key policy | <pre>list(object({<br>    principals = list(object({<br>      type = string, identifiers = list(string)<br>    }))<br>    effect    = string<br>    actions   = list(string)<br>    resources = list(string)<br>    condition = list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_custom_rds_stack_python_version"></a> [custom\_rds\_stack\_python\_version](#input\_custom\_rds\_stack\_python\_version) | Python version to use for Lambda Function | `string` | `"python3.7"` | no |
| <a name="input_custom_rds_stack_template"></a> [custom\_rds\_stack\_template](#input\_custom\_rds\_stack\_template) | A stack template to be used instead of the default DD stack template | `string` | `null` | no |
| <a name="input_datadog_api_key_secret_arn"></a> [datadog\_api\_key\_secret\_arn](#input\_datadog\_api\_key\_secret\_arn) | The ARN of a AWS SecretsManager secret containing the DD API key to be used in the forwarding stack | `string` | n/a | yes |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | The DD site to set as a parameter to the cloudFormation stack | `string` | `"datadoghq.eu"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for all resources that will take them | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags appended to all resources that will take them | `map(string)` | `{}` | no |
| <a name="input_use_vpc"></a> [use\_vpc](#input\_use\_vpc) | Whether to use VPC or not. | `bool` | `false` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | The VPC security group ids to use. Comma separated list. | `string` | `""` | no |
| <a name="input_vpc_subnet_ids"></a> [vpc\_subnet\_ids](#input\_vpc\_subnet\_ids) | The VPC subnets to use. Comma separated list. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rds_enhanced_function_arn"></a> [rds\_enhanced\_function\_arn](#output\_rds\_enhanced\_function\_arn) | n/a |
| <a name="output_rds_enhanced_function_name"></a> [rds\_enhanced\_function\_name](#output\_rds\_enhanced\_function\_name) | n/a |
| <a name="output_rds_enhanced_iam_role_arn"></a> [rds\_enhanced\_iam\_role\_arn](#output\_rds\_enhanced\_iam\_role\_arn) | n/a |
| <a name="output_rds_enhanced_iam_role_name"></a> [rds\_enhanced\_iam\_role\_name](#output\_rds\_enhanced\_iam\_role\_name) | n/a |
| <a name="output_rds_enhanced_stack_id"></a> [rds\_enhanced\_stack\_id](#output\_rds\_enhanced\_stack\_id) | n/a |
| <a name="output_rds_enhanced_stack_outputs"></a> [rds\_enhanced\_stack\_outputs](#output\_rds\_enhanced\_stack\_outputs) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
