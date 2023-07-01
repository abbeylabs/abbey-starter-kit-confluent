terraform {
  backend "http" {
    address        = "https://api.abbey.io/terraform-http-backend"
    lock_address   = "https://api.abbey.io/terraform-http-backend/lock"
    unlock_address = "https://api.abbey.io/terraform-http-backend/unlock"
    lock_method    = "POST"
    unlock_method  = "POST"
  }

  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "0.1.4"
    }

    confluent = {
      source = "confluentinc/confluent"
      version = "1.47.0"
    }
  }
}

provider "abbey" {
  # Configuration options
}

provider "confluent" {
  # Configuration options
  cloud_api_key    = var.confluent_cloud_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = var.confluent_cloud_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var

  kafka_id            = var.kafka_id                   # optionally use KAFKA_ID env var
  kafka_rest_endpoint = var.kafka_rest_endpoint        # optionally use KAFKA_REST_ENDPOINT env var
  kafka_api_key       = var.kafka_api_key              # optionally use KAFKA_API_KEY env var
  kafka_api_secret    = var.kafka_api_secret           # optionally use KAFKA_API_SECRET env var
}

resource "abbey_grant_kit" "confluent_pii_acl" {
  name = "confluent_pii_acl"
  description = "Confluent PII ACL"

  workflow = {
    steps = [
      {
        reviewers = {
          one_of = ["replace-me@example.com"]
        }
      }
    ]
  }

  policies = {
    grant_if = [
      {
        query = <<-EOT
          package main

          import data.abbey.functions

          allow[msg] {
            true; functions.expire_after("24h")
            msg := "granting access for 24 hours"
          }
        EOT
      }
    ]
  }

  output = {
    location = "github://organization/repo/access.tf"
    append = <<-EOT
      resource "kafka_acl" "principal_{{ .data.system.abbey.secondary_identities.kafka.principal }}" {
        resource_name = "syslog"
        resource_type = "Topic"
        acl_principal = "User:{{ .data.system.abbey.secondary_identities.kafka.principal }}"
        acl_host = "*"
        acl_operation = "Read"
        acl_permission_type = "Allow"
      }

      resource "confluent_kafka_acl" "describe-basic-cluster" {
        resource_type = "CLUSTER"
        resource_name = "kafka-cluster"
        pattern_type  = "LITERAL"
        principal     = "User:{{ .data.system.abbey.secondary_identities.confluent.principal }}
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

resource "abbey_identity" "user_1" {
  name = "replace-me"

  linked = jsonencode({
    abbey = [
      {
        type  = "AuthId"
        value = "replace-me@example.com"
      }
    ]

    confluent = [
      {
        principal = "replaceme"
      }
    ]
  })
}