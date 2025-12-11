locals {
  role_name = aws_iam_role.rds_role.name
  role_arn  = aws_iam_role.rds_role.arn
}

resource "aws_iam_role" "rds_role" {
  name        = "${local.resource_name_prefix}-datadog-rds"
  description = "Allows DataDog RDS Enhanced to access AWS resources"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    }
  }
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "rds_lambda_basic_execution" {
  role       = aws_iam_role.rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "rds_lambda_generic_execution" {
  role       = aws_iam_role.rds_role.name
  policy_arn = aws_iam_policy.rds_lambda.arn
}

resource "aws_iam_policy" "rds_lambda" {
  name   = "${local.resource_name_prefix}-datadog-rds-lambda-policy"
  policy = data.aws_iam_policy_document.rds_lambda.json
}

data "aws_iam_policy_document" "rds_lambda" {
  statement {
    sid = "AllowFetchDataDogAPISecret"

    actions = [
      "secretsmanager:GetSecretValue",
    ]

    resources = [var.datadog_api_key_secret_arn]
  }
  statement {
    sid = "AllowManageNetworkInterfaces"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
    ]

    resources = ["*"]
  }
}
