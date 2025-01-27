locals {
  header_api_key = "x-api-key"
}

// Rule Detail
// @see https://docs.aws.amazon.com/ja_jp/waf/latest/developerguide/aws-managed-rule-groups-list.html
resource "aws_wafv2_web_acl" "web_acl" {
  name  = "${var.name}WebACL"
  scope = var.scope

  dynamic "default_action" {
    for_each = length(var.ip_whitelist) > 0 ? [""] : []
    content {
      block {}
    }
  }

  dynamic "default_action" {
    for_each = length(var.ip_whitelist) == 0 ? [""] : []
    content {
      allow {}
    }
  }

  dynamic "rule" {
    for_each = length(var.ip_whitelist) > 0 ? [""] : []

    content {
      name     = "WAFIPsetRule"
      priority = 1

      action {
        allow {}
      }

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.waf[0].arn
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "waf-ipset-rule"
        sampled_requests_enabled   = false
      }
    }
  }

  // ボットやその他の脅威に関連付けられている IP アドレスをブロックする
  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 10

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesAmazonIpReputationListMetric"
      sampled_requests_enabled   = false
    }
  }

  // OWASP の出版物に記載されている高リスクの脆弱性や一般的な脆弱性など、幅広い脆弱性の悪用に対する保護
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 20

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        // Rule Detail
        // https://docs.aws.amazon.com/ja_jp/waf/latest/developerguide/aws-managed-rule-groups-list.html
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "SizeRestrictions_BODY"
        }
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "GenericRFI_BODY"
        }
        // MultiPartFormDataのリクエストが弾かれてしまうため設定
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "CrossSiteScripting_BODY"
        }
        // OAuthのCallbackが弾かれてしまうため設定
        rule_action_override {
          action_to_use {
            count {}
          }
          name = "GenericRFI_QUERYARGUMENTS"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

  // 既知の不正な入力ルールグループには、無効であることがわかっており脆弱性の悪用または発見に関連するリクエストパターンをブロック
  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 30

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesKnownBadInputsRuleSetMetric"
      sampled_requests_enabled   = false
    }
  }

  // Linux 固有のローカルファイルインクルージョン (LFI) 攻撃など、Linux 固有の脆弱性の悪用に関連するリクエストパターンをブロック
  rule {
    name     = "AWSManagedRulesLinuxRuleSet"
    priority = 40

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesLinuxRuleSetMetric"
      sampled_requests_enabled   = true
    }
  }

  // ビューワー ID の難読化を許可するサービスからのリクエストをブロック
  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 50

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesAnonymousIpListMetric"
      sampled_requests_enabled   = false
    }
  }

  // SQL インジェクション攻撃などの SQL データベースの悪用に関連するリクエストパターンをブロック
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 60
    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "AWSManagedRulesSQLiRuleSetMetric"
      sampled_requests_enabled   = false
    }
  }

  dynamic "rule" {
    for_each = var.bot_control_web ? [""] : []
    content {
      name     = "AWSManagedRulesBotControlRuleSetCommon"
      priority = 70

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"

          managed_rule_group_configs {
            aws_managed_rules_bot_control_rule_set {
              enable_machine_learning = true
              inspection_level        = "COMMON"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "botcontrol-common"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {
    for_each = var.bot_control_web ? [""] : []
    content {
      name     = "AWSManagedRulesBotControlRuleSetTargeted"
      priority = 80

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"

          managed_rule_group_configs {
            aws_managed_rules_bot_control_rule_set {
              enable_machine_learning = true
              inspection_level        = "TARGETED"
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "botcontrol-targeted"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {
    for_each = var.bot_control_api_key != null ? [""] : []
    content {
      name     = "AWSManagedRulesBotControlRuleSetCommon"
      priority = 70

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"

          managed_rule_group_configs {
            aws_managed_rules_bot_control_rule_set {
              enable_machine_learning = true
              inspection_level        = "COMMON"
            }
          }
          scope_down_statement {
            not_statement {
              statement {
                byte_match_statement {
                  search_string = var.bot_control_api_key
                  field_to_match {
                    single_header {
                      name = local.header_api_key
                    }
                  }
                  positional_constraint = "EXACTLY"
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "botcontrol-common"
        sampled_requests_enabled   = false
      }
    }
  }

  dynamic "rule" {
    for_each = var.bot_control_api_key != null ? [""] : []
    content {
      name     = "AWSManagedRulesBotControlRuleSetTargeted"
      priority = 80

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = "AWSManagedRulesBotControlRuleSet"
          vendor_name = "AWS"

          managed_rule_group_configs {
            aws_managed_rules_bot_control_rule_set {
              enable_machine_learning = true
              inspection_level        = "TARGETED"
            }
          }
          scope_down_statement {
            not_statement {
              statement {
                byte_match_statement {
                  search_string = var.bot_control_api_key
                  field_to_match {
                    single_header {
                      name = local.header_api_key
                    }
                  }
                  positional_constraint = "EXACTLY"
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = false
        metric_name                = "botcontrol-targeted"
        sampled_requests_enabled   = false
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "TerraformWebACLMetric"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl_association" "alb_waf" {
  count = var.alb_arn == "" ? 0 : 1

  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
  depends_on = [
    aws_wafv2_web_acl.web_acl,
  ]
}

resource "aws_wafv2_web_acl_logging_configuration" "logging_conf" {
  count = var.logging.enable ? 1 : 0

  log_destination_configs = [var.logging.delivery_stream_arn]
  resource_arn            = aws_wafv2_web_acl.web_acl.arn

  redacted_fields {
    method {}
  }

  redacted_fields {
    query_string {}
  }

  redacted_fields {
    uri_path {}
  }

  redacted_fields {
    single_header {
      name = "user-agent"
    }
  }

  depends_on = [aws_wafv2_web_acl.web_acl]
}

resource "aws_wafv2_ip_set" "waf" {
  count = var.ip_whitelist == [] ? 0 : 1

  name               = var.name
  scope              = var.scope
  ip_address_version = "IPV4"
  addresses          = var.ip_whitelist
}
