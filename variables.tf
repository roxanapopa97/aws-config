variable "aws_config_role_name" {
  description = "(Optional) Name of the role used for AWS Config initial setup"  
  type        = string
  default     = "aws-config-iam-role"
}

variable "setup_config" {
  description = "(Required) Set to true if AWS Config initial configuration should be performed"
  type        = bool
}

variable "aws_config_role_name" {
  description = "(Optional) Name of the IAM role used for AWS Config initial setup"
  type        = string
  default     = "aws-config-iam-role"
}

variable "aws_config_role_policy_name" {
  description = "(Optional) Name of the IAM Policy used for AWS Config initial setup"
  type        = string
  default     = "aws-config-allow-bucket-policy"
}

variable "aws_config_bucket_name" {
  description = "(Required if setup_config == true) Name of the S3 bucket used in AWS Config initial setup"
  type        = string
  default     = null 
}

variable "aws_config_delivery_channel_name" {
  description = "Name of the delivery channel used in AWS Config initial setup"
  type        = string
  default     = "aws-config-delivery-channel"
}

variable "aws_config_configuration_recorder_name" {
  description = "Name of the configuration recorder used in AWS Config initial setup"
  type        = string
  default     = "aws-config-configuration-recorder"
}