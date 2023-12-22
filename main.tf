locals {
  account_name = ""
  repo_name = ""

  project_path = "github://${local.account_name}/${local.repo_name}"
  policies_path = "${local.project_path}/policies"
}

resource "abbey_grant_kit" "confluent_pii_acl" {
  name = "confluent_pii_acl"
  description = "Confluent PII ACL"

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = ["replace-me@example.com"] # CHANGEME
        }
      }
    ]
  }

  policies = [
    { bundle = local.policies_path }
  ]

  output = {
    location = "${local.project_path}/access.tf"
    append = <<-EOT
      resource "confluent_kafka_acl" "describe-basic-cluster" {
        resource_type = "CLUSTER"
        resource_name = "kafka-cluster"
        pattern_type  = "LITERAL"
        principal     = "User:{{ .user.confluent.principal }}
        host          = "*"
        operation     = "DESCRIBE"
        permission    = "ALLOW"

        lifecycle {
          prevent_destroy = true
        }
      }
    EOT
  }
}
