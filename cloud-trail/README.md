# cloudtrail

Terraform module to setup CloudTrail.

CloudTrail logs calls made to the AWS APIs, and sends those logs to a S3 bucket.
It can additionally also send logs to a CloudWatch log group and to an SNS topic.
When using CloudWatch log groups as destination for its logs, CloudTrail can assume a IAM role that gives it permission to write the logs.
However, when using S3 buckets as destination for the logs, CloudTrail cannot assume a IAM role which means that permission needs to be set on the S3 bucket.
See [CloudTrail IAM docs](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/security-iam.html).

## Examples

This module ships with usage examples.
Please see the [examples directory](./examples):
* [log-to-s3](./examples/log-to-s3)
* [log-to-s3-and-cloudwatch](./examples/log-to-s3-and-cloudwatch)
* [log-to-s3-with-cmk](./examples/log-to-s3-with-cmk)
* [log-to-s3-with-cmk-and-object-locking](./examples/log-to-s3-with-cmk-and-object-locking)
* [log-to-s3-with-s3-kms](./examples/log-to-s3-with-s3-kms)

## Code origin

The code has been forked from https://github.com/cloudposse/terraform-aws-cloudtrail because there were some aspects I wanted to custom (eg. set my own tags on resources).
I first tried to contribute to the original module, but I got no feedback at all on my PRs:
* https://github.com/cloudposse/terraform-aws-cloudtrail/pull/29
* https://github.com/cloudposse/terraform-aws-s3-log-storage/pull/20
* https://github.com/cloudposse/terraform-aws-cloudtrail-s3-bucket/pull/16
