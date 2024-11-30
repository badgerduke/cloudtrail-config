resource "aws_config_configuration_recorder" "demo_config_recorder" {
    name     = "demo-config-recorder"
    role_arn = aws_iam_role.aws_config_role.arn

    recording_group {
      all_supported  = false
      resource_types = ["AWS::EC2::SecurityGroup"]
    }

    recording_mode {
      recording_frequency = "CONTINUOUS"
    }
  
}

resource "aws_config_delivery_channel" "demo_config_delivery_channel" {
    s3_bucket_name = aws_s3_bucket.aws_config_bucket.bucket
}

resource "aws_config_configuration_recorder_status" "demo_config_recorder_status" {
    name       = aws_config_configuration_recorder.demo_config_recorder.name 
    is_enabled = true
    depends_on = [
      aws_config_delivery_channel.demo_config_delivery_channel
    ]

}

resource "aws_iam_role" "aws_config_role" {
  name               = "demo-aws-config-role"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Principal": {
                "Service": "config.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
}

resource "aws_iam_policy" "aws_config_sns_policy" {
  name        = "demo-aws-config-sns-policy"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "sns:Publish"
        ],
        "Resource": [
          "${aws_sns_topic.example_sns_topic.arn}*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_config_role_policy_attachment" {
  role       = aws_iam_role.aws_config_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "aws_s3_bucket" "aws_config_bucket" {
  bucket        = var.aws_config_S3_name
  force_destroy = true
}

resource "aws_s3_bucket_policy" "allow_access_aws_config" {
  bucket = aws_s3_bucket.aws_config_bucket.id
  policy = data.aws_iam_policy_document.aws_config_s3_bucket_policy.json
}


data "aws_iam_policy_document" "aws_config_s3_bucket_policy" {
  statement {
    sid    = "AWSConfigBucketPermissionsCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.aws_config_bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }

  statement {
    sid    = "AWSConfigBucketExistenceCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.aws_config_bucket.arn]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }


  statement {
    sid    = "AWSConfigBucketDelivery"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["config.amazonaws.com"]
    }

    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.aws_config_bucket.arn}/AWSLogs/093879445146/Config/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }  
}