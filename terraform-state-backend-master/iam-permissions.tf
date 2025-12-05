locals {
  # filter out users and roles for which the ARN has a wildcard '*'
  users_to_attach_policy = [for user_arn in var.users : replace(user_arn, "/^[a-z0-9:/]+[/]/", "")]
  roles_to_attach_policy = [for role_arn in var.roles : replace(role_arn, "/^[a-z0-9:/]+[/]/", "")]
}

resource "aws_iam_policy" "tf_backend" {
  name        = module.s3_bucket.s3_bucket_id
  path        = "/"
  description = "Provides access to ${module.s3_bucket.s3_bucket_id} and respective DynamoDB table and KMS key"

  policy = data.aws_iam_policy_document.tf_backend_full_policy.json
}

data "aws_iam_policy_document" "tf_backend_full_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketVersioning"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]

    resources = ["arn:aws:dynamodb:*:*:table/${var.bucket_name}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt", "kms:Encrypt"]
    resources = [module.cmk.key_arn, module.cmk.key_alias_arn]
  }

  statement {
    # Allow to lock state (needed for plan)
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [local.dynamodb_table_arn]
  }
}

resource "aws_iam_user_policy_attachment" "tf_backend" {
  for_each = toset(local.users_to_attach_policy)

  user       = each.key
  policy_arn = aws_iam_policy.tf_backend.arn
}

resource "aws_iam_role_policy_attachment" "tf_backend" {
  for_each = toset(local.roles_to_attach_policy)

  role       = each.key
  policy_arn = aws_iam_policy.tf_backend.arn
}
