variable "cloudtrail_event_name" {
 type = string
 description = "The cloudtrail event name to search for"
}

variable "security_group_name" {
 type = string
 description = "The name of the security group"
}

variable "sns_topic_name" {
 type = string
 description = "The name of the SNS topic"
}

variable "sns_email" {
 type = string
 description = "The email address subscibing to the SNS topic"
}

variable "aws_config_S3_name" {
 type = string
 description = "The name of the S3 bucket storing the AWS Config resource monitoring information"
}

variable "eventbridge_rule_name" {
 type = string
 description = "The name of the EventBridge rule triggered by AWS Config"
}