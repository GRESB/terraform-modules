# config-managed-rules

Terraform module to setup AWS Config managed rules https://docs.aws.amazon.com/config/latest/developerguide/managed-rules-by-aws-config.html

AWS Config requires permissions to access the S3 bucket where it will store its logs, and an SNS topic where it sends notifications.
The module can create a default S3 bucket for the logs with permissions setup for AWS Config.
This module sets up an IAM role with policies to provide access to the S3 bucket that is provided as an argument to the module or the bucket the module creates.
See https://docs.aws.amazon.com/config/latest/developerguide/iamrole-permissions.html for the required permissions.

AWS Config does not work if (1) object level locking is enabled on the S3 bucket.
In order to use a KMS Customer Master Key the policy on the key needs to allow AWS Config to generate a data key. See [example with CMK for how to do that](./examples/complete-with-cmk/test-main.tf). 

AWS Config is able to record and aggregate logs from different accounts, across all regions.
Use this module in the account that will aggregate the logs, set `enable_aggregation = true` and pass the IDs for the other accounts in via `aggregated_accounts = ["222222222222"]`.
To configure the other accounts to allow collection of resource logs from the aggregator account use the `aws_config_aggregate_authorization` resource to establish trust between the accounts.
```hcl
resource "aws_config_aggregate_authorization" "example" {
  account_id = "11111111111"  # id of account where logs will be aggregated
  region     = "eu-west-1"
}
```


## Custom policy template files

Certain checks (like the IAM user password) are configured with a policy document that specified the compliance rules to be checked. 
This module offers default templates for that, but in case users wants to provide their own templates they can pass in a path to a directory where the templates will be found.
Setting `custom_policy_templates_path = <path>` will make the module look for templates in that path.
The module will expect to find the following templates:
* `iam-user-password-policy.json.tpl` to configure the IAM user password policy check. https://docs.aws.amazon.com/config/latest/developerguide/iam-password-policy.html
 

## Backlog test cross account aggregation
This needs more than one account.
