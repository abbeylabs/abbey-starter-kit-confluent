variable "abbey_token" {
  type = string
  sensitive = true
  description = "Abbey API Token"
}

variable "confluent_cloud_api_key" {
  type = string
  sensitive = true
  description = "Confluent Cloud API Key"
}
variable "confluent_cloud_api_secret" {
  type = string
  sensitive = true
  description = "Confluent Cloud API Secret"
}
variable "kafka_id" {
  type = string
  sensitive = true
  description = "Kafka Cluster ID"
  default = "replaceme"
}
variable "kafka_rest_endpoint" {
  type = string
  sensitive = true
  description = "Kafka REST Endpoint"
  default = "replaceme"
}
variable "kafka_api_key" {
  type = string
  sensitive = true
  description = "Kafka API Key"
}
variable "kafka_api_secret" {
  type = string
  sensitive = true
  description = "Kafka API Secret"
}