variable "create_aggregator" {
  description = "(Required) Set to true if a config aggregator should be created"
  type        = bool
}

variable "config_aggregator_role_name" {
  description = "(Optional) Name of the IAM role used for Config Aggregator"
  type        = string
  default     = "aws-config-aggregator-iam-role"
}

variable "config_aggregator_name" {
  description = "(Optional) Name of the Config Aggregator"
  type        = string
  default     = "aws-config-aggregator"
}