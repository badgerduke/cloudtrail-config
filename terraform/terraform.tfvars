# The metric filter pattern 
cloudtrail_event_name = "ModifySecurityGroupRules"

# The name of the security group
security_group_name = "demo-sg"

# The name of the SNS topic
sns_topic_name = "demo-sns"

# The email address subscibing to the SNS topic
sns_email = "erichamacher@protonmail.com"

# The name of the S3 bucket storing the AWS Config resource monitoring information
aws_config_S3_name = "demo-config-bucket-1"

# The name of the EventBridge rule triggered by AWS Config
eventbridge_rule_name = "demo-eventbridge-rule"