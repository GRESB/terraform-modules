#######################################################################################################################
# Apply specific permissions on paths in the S3 bucket
#######################################################################################################################
locals {
  path_based_users_to_attach_policy = { for item, config in var.path_based_permissions : item => config if config.principal_type == "user" }
  path_based_roles_to_attach_policy = { for item, config in var.path_based_permissions : item => config if config.principal_type == "role" }
}

resource "aws_iam_policy" "tf_backend_path_based" {
  for_each = var.path_based_permissions

  name        = "${var.s3_bucket_name}-${each.key}"
  path        = "/"
  description = "Provides ${each.value.principal_name} ${each.value.principal_type} with ${each.value.action} access to ${var.s3_bucket_name} and respective DynamoDB table and KMS key"

  policy = data.aws_iam_policy_document.tf_backend_bath_based[each.key].json
}

data "aws_iam_policy_document" "tf_backend_bath_based" {
  for_each = var.path_based_permissions

  statement {
    effect    = "Allow"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::*"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetBucketVersioning"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}"]
  }

  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = formatlist("arn:aws:s3:::${var.s3_bucket_name}/%s", each.value.paths)
  }

  dynamic "statement" {
    for_each = each.value.action == "read-write" ? ["enabled"] : []

    content {
      effect    = "Allow"
      actions   = ["s3:PutObject"]
      resources = formatlist("arn:aws:s3:::${var.s3_bucket_name}/%s", each.value.paths)
    }
  }

  statement {
    effect = "Allow"

    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
    ]

    resources = ["arn:aws:dynamodb:*:*:table/${var.s3_bucket_name}"]
  }

  dynamic "statement" {
    for_each = each.value.action == "read-write" ? ["enabled"] : []
    content {
      effect = "Allow"

      actions = [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
      ]

      resources = ["arn:aws:dynamodb:*:*:table/${var.s3_bucket_name}"]
    }
  }

  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = [var.cmk_key_arn, var.cmk_key_alias_arn]
  }

  dynamic "statement" {
    for_each = each.value.action == "read-write" ? ["enabled"] : []
    content {
      effect    = "Allow"
      actions   = ["kms:Encrypt"]
      resources = [var.cmk_key_arn, var.cmk_key_alias_arn]
    }
  }

  statement {
    # Allow to lock state (needed for plan)
    effect = "Allow"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:DeleteItem"
    ]
    resources = [var.dynamodb_table_arn]
  }
}

resource "aws_iam_user_policy_attachment" "tf_backend_path_based" {
  for_each = local.path_based_users_to_attach_policy

  user       = each.value.principal_name
  policy_arn = aws_iam_policy.tf_backend_path_based[each.key].arn
}

resource "aws_iam_role_policy_attachment" "tf_backend_path_based" {
  for_each = local.path_based_roles_to_attach_policy

  role       = each.value.principal_name
  policy_arn = aws_iam_policy.tf_backend_path_based[each.key].arn
}
