resource "aws_cognito_user_group" "groups" {
  count = length(keys(var.user_pool_groups))

  name        = element(keys(var.user_pool_groups), count.index)
  description = element(values(var.user_pool_groups), count.index)

  user_pool_id = aws_cognito_user_pool.default.id
}
