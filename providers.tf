provider "abbey" {
  # Configuration options
  bearer_auth = var.abbey_token
}

provider "confluent" {
  # Configuration options
  cloud_api_key       = var.confluent_cloud_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret    = var.confluent_cloud_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var

  kafka_id            = var.kafka_id                   # optionally use KAFKA_ID env var
  kafka_rest_endpoint = var.kafka_rest_endpoint        # optionally use KAFKA_REST_ENDPOINT env var
  kafka_api_key       = var.kafka_api_key              # optionally use KAFKA_API_KEY env var
  kafka_api_secret    = var.kafka_api_secret           # optionally use KAFKA_API_SECRET env var
}
