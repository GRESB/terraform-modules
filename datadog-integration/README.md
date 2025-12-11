# datadog-integration

Terraform module to setup integration between DataDog and AWS.

This module is able to:
* provision the integration between DD and AWs
* provision a log forwarding stack: https://docs.datadoghq.com/integrations/amazon_web_services/?tab=allpermissions#log-collection
* provision an RDS Enhanced OS metrics forwarding stack: https://docs.datadoghq.com/integrations/amazon_rds/#enhanced-rds-integration

## Log forwarder

The log forwarder is an embedded CloudFormation stack.
To use this, make sure you have the required DataDog API secret pre-created.
This is a change from the original.
Another is that we substitute the implicit role created by SAM for an explicitly created one.

## Terraform docs

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.33 |
| <a name="requirement_datadog"></a> [datadog](#requirement\_datadog) | ~> 3.16 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.67.0 |
| <a name="provider_datadog"></a> [datadog](#provider\_datadog) | 3.27.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_log_forwarder_stack"></a> [log\_forwarder\_stack](#module\_log\_forwarder\_stack) | ./modules/log-forwarder-stack | n/a |
| <a name="module_rds_enhanced_stack"></a> [rds\_enhanced\_stack](#module\_rds\_enhanced\_stack) | ./modules/rds-enhanced-stack | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.datadog_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.datadog_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.datadog_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.datadog_integration_security_audit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_secretsmanager_secret.datadog_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.datadog_credentials](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |
| [datadog_integration_aws.integration](https://registry.terraform.io/providers/datadog/datadog/latest/docs/resources/integration_aws) | resource |
| [random_string.datadog_credentials](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.datadog_integration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_secretsmanager_secret.datadog_api_key_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/secretsmanager_secret) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_specific_namespace_rules"></a> [account\_specific\_namespace\_rules](#input\_account\_specific\_namespace\_rules) | Enable/disable specific AWS services from being monitored. Defaults to all enabled | `map(bool)` | <pre>{<br>  "api_gateway": true,<br>  "application_elb": true,<br>  "apprunner": true,<br>  "appstream": true,<br>  "appsync": true,<br>  "athena": true,<br>  "auto_scaling": true,<br>  "billing": true,<br>  "budgeting": true,<br>  "certificatemanager": true,<br>  "cloudfront": true,<br>  "cloudhsm": true,<br>  "cloudsearch": true,<br>  "cloudwatch_events": true,<br>  "cloudwatch_logs": true,<br>  "codebuild": true,<br>  "cognito": true,<br>  "collect_custom_metrics": true,<br>  "connect": true,<br>  "crawl_alarms": true,<br>  "directconnect": true,<br>  "dms": true,<br>  "documentdb": true,<br>  "dynamodb": true,<br>  "ebs": true,<br>  "ec2": true,<br>  "ec2api": true,<br>  "ec2spot": true,<br>  "ecs": true,<br>  "efs": true,<br>  "elasticache": true,<br>  "elasticbeanstalk": true,<br>  "elasticinference": true,<br>  "elastictranscoder": true,<br>  "elb": true,<br>  "emr": true,<br>  "es": true,<br>  "firehose": true,<br>  "fsx": true,<br>  "gamelift": true,<br>  "glue": true,<br>  "inspector": true,<br>  "iot": true,<br>  "kinesis": true,<br>  "kinesis_analytics": true,<br>  "kms": true,<br>  "lambda": true,<br>  "lex": true,<br>  "mediaconnect": true,<br>  "mediaconvert": true,<br>  "mediapackage": true,<br>  "mediatailor": true,<br>  "ml": true,<br>  "mq": true,<br>  "msk": true,<br>  "nat_gateway": true,<br>  "neptune": true,<br>  "network_elb": true,<br>  "networkfirewall": true,<br>  "opsworks": true,<br>  "polly": true,<br>  "rds": true,<br>  "redshift": true,<br>  "rekognition": true,<br>  "route53": true,<br>  "route53resolver": true,<br>  "s3": true,<br>  "s3storagelens": true,<br>  "sagemaker": true,<br>  "ses": true,<br>  "shield": true,<br>  "sns": true,<br>  "sqs": true,<br>  "step_functions": true,<br>  "storage_gateway": true,<br>  "swf": true,<br>  "transitgateway": true,<br>  "translate": true,<br>  "trusted_advisor": true,<br>  "usage": true,<br>  "vpn": true,<br>  "waf": true,<br>  "wafv2": true,<br>  "workspaces": true,<br>  "xray": true<br>}</pre> | no |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | The ID of the AWS account to integrate with DD | `string` | `null` | no |
| <a name="input_create_datadog_api_key_secret"></a> [create\_datadog\_api\_key\_secret](#input\_create\_datadog\_api\_key\_secret) | Whether to create a AWS SecretsManager secret for DD API key, when set to false `datadog_api_key_secret_arn` must be set to a valid ARN | `bool` | `true` | no |
| <a name="input_custom_datadog_rds_stack_template"></a> [custom\_datadog\_rds\_stack\_template](#input\_custom\_datadog\_rds\_stack\_template) | A stack template to be used instead of the default DD stack template | `string` | `null` | no |
| <a name="input_custom_rds_stack_kms_key_policy"></a> [custom\_rds\_stack\_kms\_key\_policy](#input\_custom\_rds\_stack\_kms\_key\_policy) | A addition KMS Key policy | <pre>list(object({<br>    principals = list(object({<br>      type = string, identifiers = list(string)<br>    }))<br>    effect    = string<br>    actions   = list(string)<br>    resources = list(string)<br>    condition = list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_custom_rds_stack_python_version"></a> [custom\_rds\_stack\_python\_version](#input\_custom\_rds\_stack\_python\_version) | Python version to use for Lambda Function | `string` | `"python3.7"` | no |
| <a name="input_datadog_api_key"></a> [datadog\_api\_key](#input\_datadog\_api\_key) | The API key used for the DataDog provider | `string` | `""` | no |
| <a name="input_datadog_api_key_secret_arn"></a> [datadog\_api\_key\_secret\_arn](#input\_datadog\_api\_key\_secret\_arn) | The ARN of a pre-existing AWS SecretsManager secret containing the DD API key to be used in the forwarding stack. Conflicts with `create_forwarder_api_key_secret`. | `string` | `""` | no |
| <a name="input_datadog_code_s3_bucket"></a> [datadog\_code\_s3\_bucket](#input\_datadog\_code\_s3\_bucket) | The bucket where the lambda function packages can be found. | `string` | `null` | no |
| <a name="input_datadog_forwarder_bucket_subscriptions"></a> [datadog\_forwarder\_bucket\_subscriptions](#input\_datadog\_forwarder\_bucket\_subscriptions) | Map of bucket names to a pairs of bucket ARN and KMS key ARN. This map is used to configure forwarding logs from the respective buckets to DD. | <pre>map(object({<br>    bucket_arn   = string<br>    is_encrypted = bool<br>    kms_key_arn  = string<br>  }))</pre> | `{}` | no |
| <a name="input_datadog_forwarder_cloudwatch_event_subscriptions"></a> [datadog\_forwarder\_cloudwatch\_event\_subscriptions](#input\_datadog\_forwarder\_cloudwatch\_event\_subscriptions) | Map of CloudWatch event subscriptions. | <pre>map(object({<br>    source      = string<br>    detail_type = string<br>  }))</pre> | `{}` | no |
| <a name="input_datadog_forwarder_cloudwatch_log_group_subscriptions"></a> [datadog\_forwarder\_cloudwatch\_log\_group\_subscriptions](#input\_datadog\_forwarder\_cloudwatch\_log\_group\_subscriptions) | Map of CloudWatch log group subscriptions. | <pre>map(object({<br>    log_group_name              = string<br>    subscription_filter_pattern = string<br>  }))</pre> | `{}` | no |
| <a name="input_datadog_forwarder_include_at_match"></a> [datadog\_forwarder\_include\_at\_match](#input\_datadog\_forwarder\_include\_at\_match) | Regex pattern on which to filter. if set to empty string, no filtering is applied | `string` | `""` | no |
| <a name="input_datadog_forwarder_use_vpc"></a> [datadog\_forwarder\_use\_vpc](#input\_datadog\_forwarder\_use\_vpc) | Whether to use VPC or not. | `bool` | `false` | no |
| <a name="input_datadog_forwarder_vpc_security_group_ids"></a> [datadog\_forwarder\_vpc\_security\_group\_ids](#input\_datadog\_forwarder\_vpc\_security\_group\_ids) | The VPC security group ids to use. Comma separated list. | `string` | `""` | no |
| <a name="input_datadog_forwarder_vpc_subnet_ids"></a> [datadog\_forwarder\_vpc\_subnet\_ids](#input\_datadog\_forwarder\_vpc\_subnet\_ids) | The VPC subnets to use. Comma separated list. | `string` | `""` | no |
| <a name="input_datadog_rds_cloudwatch_log_group_name"></a> [datadog\_rds\_cloudwatch\_log\_group\_name](#input\_datadog\_rds\_cloudwatch\_log\_group\_name) | The name of the CloudWatch log group for RDS OS metrics | `string` | `"RDSOSMetrics"` | no |
| <a name="input_datadog_rds_cloudwatch_subscription_distribution"></a> [datadog\_rds\_cloudwatch\_subscription\_distribution](#input\_datadog\_rds\_cloudwatch\_subscription\_distribution) | The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are "Random" and "ByLogStream". | `string` | `"Random"` | no |
| <a name="input_datadog_rds_cloudwatch_subscription_filter_pattern"></a> [datadog\_rds\_cloudwatch\_subscription\_filter\_pattern](#input\_datadog\_rds\_cloudwatch\_subscription\_filter\_pattern) | A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. | `string` | `""` | no |
| <a name="input_datadog_rds_code_s3_object"></a> [datadog\_rds\_code\_s3\_object](#input\_datadog\_rds\_code\_s3\_object) | The bucket object with the lambda function. Source https://github.com/DataDog/datadog-serverless-functions/tree/master/aws/rds_enhanced_monitoring | `string` | `null` | no |
| <a name="input_datadog_rds_configure_subscription"></a> [datadog\_rds\_configure\_subscription](#input\_datadog\_rds\_configure\_subscription) | Whether to enable the CloudWatch log subscription and ship logs to DD | `bool` | `false` | no |
| <a name="input_datadog_rds_use_vpc"></a> [datadog\_rds\_use\_vpc](#input\_datadog\_rds\_use\_vpc) | Whether to use VPC or not. | `bool` | `false` | no |
| <a name="input_datadog_rds_vpc_security_group_ids"></a> [datadog\_rds\_vpc\_security\_group\_ids](#input\_datadog\_rds\_vpc\_security\_group\_ids) | The VPC security group ids to use. Comma separated list. | `string` | `""` | no |
| <a name="input_datadog_rds_vpc_subnet_ids"></a> [datadog\_rds\_vpc\_subnet\_ids](#input\_datadog\_rds\_vpc\_subnet\_ids) | The VPC subnets to use. Comma separated list. | `string` | `""` | no |
| <a name="input_datadog_site"></a> [datadog\_site](#input\_datadog\_site) | The DD site to set as a parameter to the cloudFormation stack | `string` | `"datadoghq.eu"` | no |
| <a name="input_enable_datadog_forwarder_stack"></a> [enable\_datadog\_forwarder\_stack](#input\_enable\_datadog\_forwarder\_stack) | Whether to enable the DD forwarder lambda stack | `bool` | `false` | no |
| <a name="input_enable_datadog_rds_stack"></a> [enable\_datadog\_rds\_stack](#input\_enable\_datadog\_rds\_stack) | Whether to enable the DD RDS Enhanced lambda stack | `bool` | `false` | no |
| <a name="input_enable_security_audit_iam"></a> [enable\_security\_audit\_iam](#input\_enable\_security\_audit\_iam) | Whether to attach the SecurityAudit IAM policy to the DataDog integration role. | `bool` | `false` | no |
| <a name="input_filter_tags"></a> [filter\_tags](#input\_filter\_tags) | Tags used to filter which resources should be monitored by datadog. Set to empty map to monitor all resources. | `map(string)` | <pre>{<br>  "com.datadoghq.app": "enabled"<br>}</pre> | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Name prefix for all resources that will take them | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags appended to all resources that will take them | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_datadog_api_key_secret_arn"></a> [datadog\_api\_key\_secret\_arn](#output\_datadog\_api\_key\_secret\_arn) | n/a |
| <a name="output_datadog_integration_role_arn"></a> [datadog\_integration\_role\_arn](#output\_datadog\_integration\_role\_arn) | n/a |
| <a name="output_datadog_integration_role_name"></a> [datadog\_integration\_role\_name](#output\_datadog\_integration\_role\_name) | n/a |
| <a name="output_datadog_log_forwarder_function_arn"></a> [datadog\_log\_forwarder\_function\_arn](#output\_datadog\_log\_forwarder\_function\_arn) | n/a |
| <a name="output_datadog_log_forwarder_function_name"></a> [datadog\_log\_forwarder\_function\_name](#output\_datadog\_log\_forwarder\_function\_name) | n/a |
| <a name="output_datadog_log_forwarder_iam_role_arn"></a> [datadog\_log\_forwarder\_iam\_role\_arn](#output\_datadog\_log\_forwarder\_iam\_role\_arn) | n/a |
| <a name="output_datadog_log_forwarder_iam_role_name"></a> [datadog\_log\_forwarder\_iam\_role\_name](#output\_datadog\_log\_forwarder\_iam\_role\_name) | n/a |
| <a name="output_datadog_log_forwarder_stack_id"></a> [datadog\_log\_forwarder\_stack\_id](#output\_datadog\_log\_forwarder\_stack\_id) | n/a |
| <a name="output_datadog_log_forwarder_stack_outputs"></a> [datadog\_log\_forwarder\_stack\_outputs](#output\_datadog\_log\_forwarder\_stack\_outputs) | n/a |
| <a name="output_datadog_rds_enhanced_function_arn"></a> [datadog\_rds\_enhanced\_function\_arn](#output\_datadog\_rds\_enhanced\_function\_arn) | n/a |
| <a name="output_datadog_rds_enhanced_function_name"></a> [datadog\_rds\_enhanced\_function\_name](#output\_datadog\_rds\_enhanced\_function\_name) | n/a |
| <a name="output_datadog_rds_enhanced_iam_role_arn"></a> [datadog\_rds\_enhanced\_iam\_role\_arn](#output\_datadog\_rds\_enhanced\_iam\_role\_arn) | n/a |
| <a name="output_datadog_rds_enhanced_iam_role_name"></a> [datadog\_rds\_enhanced\_iam\_role\_name](#output\_datadog\_rds\_enhanced\_iam\_role\_name) | n/a |
| <a name="output_datadog_rds_enhanced_stack_id"></a> [datadog\_rds\_enhanced\_stack\_id](#output\_datadog\_rds\_enhanced\_stack\_id) | n/a |
| <a name="output_datadog_rds_enhanced_stack_outputs"></a> [datadog\_rds\_enhanced\_stack\_outputs](#output\_datadog\_rds\_enhanced\_stack\_outputs) | n/a |
| <a name="output_datadog_secret_name"></a> [datadog\_secret\_name](#output\_datadog\_secret\_name) | n/a |
| <a name="output_filter_tags"></a> [filter\_tags](#output\_filter\_tags) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
