module "path_based_permissions" {
  source = "./modules/path-based-permissions"

  path_based_permissions = var.path_based_permissions
  s3_bucket_name         = local.s3_bucket_id
  cmk_key_arn            = local.cmk_key_arn
  cmk_key_alias_arn      = local.cmk_key_alias_arn
  dynamodb_table_arn     = local.dynamodb_table_arn
}
