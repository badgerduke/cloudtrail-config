resource "aws_cloudwatch_event_rule" "rule_for_sg_change" {
  name          = var.eventbridge_rule_name

  event_pattern = <<EOF
    {
      "source": [
        "aws.config"
      ],
      "detail-type": ["Config Configuration Item Change"],
      "detail": {
        "messageType": ["ConfigurationItemChangeNotification"],
        "configurationItem": {
          "resourceType": ["AWS::EC2::SecurityGroup"],
          "resourceId": ["${aws_security_group.example.id}"]
        }
      }
    }
  EOF
}  

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.rule_for_sg_change.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.example_sns_topic.arn
}