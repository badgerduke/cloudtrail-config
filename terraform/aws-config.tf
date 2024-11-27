resource "aws_config_configuration_recorder" "demo_config_recorder" {
    name = ""
    role_arn = ""

    recording_group {
      resource_types = ["AWS::EC2::SecurityGroup"]
    }

    recording_mode {
      recording_frequency = "CONTINUOUS"
    }
  
}

resource "aws_config_delivery_channel" "demo_config_delivery_channel" {
    s3_bucket_name = ""
  
}

resource "aws_config_configuration_recorder_status" "demo_config_recorder_status" {
    name       = "" 
    is_enabled = true

  
}