locals {
  is_guardduty_master = var.enabled && var.is_guardduty_master

  bucket = var.create_s3_bucket ? one(aws_s3_bucket.created[*].id) : var.s3_bucket_name
}

resource "aws_s3_object" "ipset" {
  count = local.is_guardduty_master && local.has_ipset ? 1 : 0

  bucket = local.bucket
  key    = local.ipset_key

  acl = "public-read"

  content = templatefile("${path.module}/files/templates/ipset.txt.tpl",
    {
      ipset_iplist = var.ipset_iplist
  })

  tags = var.tags
}

resource "aws_guardduty_ipset" "ipset" {
  count = local.is_guardduty_master && local.has_ipset ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)
  name        = local.ipset_name
  activate    = var.activate_ipset
  format      = var.ipset_format
  location    = "https://s3.amazonaws.com/${local.bucket}/${local.ipset_key}"

  depends_on = [aws_s3_object.ipset]
}

resource "aws_s3_object" "threatintelset" {
  count = local.is_guardduty_master && local.has_threatintelset ? 1 : 0

  bucket = local.bucket
  key    = local.threatintelset_key

  acl = "public-read"

  content = templatefile("${path.module}/files/templates/threatintelset.txt.tpl",
    {
      threatintelset_iplist = var.threatintelset_iplist
  })

  tags = var.tags
}

resource "aws_guardduty_threatintelset" "threatintelset" {
  count = local.is_guardduty_master && local.has_threatintelset ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)
  name        = local.threatintelset_name
  activate    = var.activate_threatintelset
  format      = var.threatintelset_format
  location    = "https://s3.amazonaws.com/${local.bucket}/${local.threatintelset_key}"

  depends_on = [aws_s3_object.threatintelset]
}

resource "aws_guardduty_organization_configuration" "org" {
  count = var.enable_organization ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)

  auto_enable_organization_members = var.auto_enable_organization_members
}

# Org-wide auto-enable features. Only the org master/delegated admin can set
# these, and they reference the detector id, so they must be gated on the same
# condition as the other master-only resources — otherwise `detector_id`
# resolves to null in accounts where no detector is created (e.g. members).
resource "aws_guardduty_organization_configuration_feature" "org_s3_log" {
  count = local.is_guardduty_master && var.enable_organization ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)

  name        = "S3_DATA_EVENTS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "org_k8s_log" {
  count = local.is_guardduty_master && var.enable_organization ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)

  name        = "EKS_AUDIT_LOGS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "org_malware_protection" {
  count = local.is_guardduty_master && var.enable_organization ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)

  name        = "EBS_MALWARE_PROTECTION"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "org_rds_login" {
  count = local.is_guardduty_master && var.enable_organization ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)

  name        = "RDS_LOGIN_EVENTS"
  auto_enable = "ALL"
}

resource "aws_guardduty_organization_configuration_feature" "org_lambda_network" {
  count = local.is_guardduty_master && var.enable_organization ? 1 : 0

  detector_id = one(aws_guardduty_detector.detector[*].id)

  name        = "LAMBDA_NETWORK_LOGS"
  auto_enable = "ALL"
}

# Preserve state for consumers upgrading from a version where these features had
# no count (unindexed -> [0]), so the guard does not destroy/recreate them.
moved {
  from = aws_guardduty_organization_configuration_feature.org_s3_log
  to   = aws_guardduty_organization_configuration_feature.org_s3_log[0]
}

moved {
  from = aws_guardduty_organization_configuration_feature.org_k8s_log
  to   = aws_guardduty_organization_configuration_feature.org_k8s_log[0]
}

moved {
  from = aws_guardduty_organization_configuration_feature.org_malware_protection
  to   = aws_guardduty_organization_configuration_feature.org_malware_protection[0]
}

resource "aws_guardduty_member" "members" {
  count = local.is_guardduty_master && !var.enable_organization ? length(var.member_list) : 0

  detector_id        = one(aws_guardduty_organization_configuration.org[*].detector_id)
  invitation_message = "Please accept GuardDuty invitation"

  account_id = var.member_list[count.index]["account_id"]
  email      = var.member_list[count.index]["member_email"]

  invite = var.member_list[count.index]["invite"]
}

// seperate resource to manage lifecycle changes and dependencies
resource "aws_guardduty_member" "organizations_members" {
  count = local.is_guardduty_master && var.enable_organization ? length(var.member_list) : 0

  detector_id        = one(aws_guardduty_detector.detector[*].id)
  invitation_message = "Please accept GuardDuty invitation"

  account_id = var.member_list[count.index]["account_id"]
  email      = var.member_list[count.index]["member_email"]

  # do not directly invite if using the organizations option
  invite = false

  lifecycle {
    ignore_changes = [
      email,
      invite,
    ]
  }
}
