terraform {
  required_providers {
    abbey = {
      source = "abbeylabs/abbey"
      version = "~> 0.2.6"
    }

    confluent = {
      source = "confluentinc/confluent"
      version = "~> 1.47.0"
    }
  }
}
