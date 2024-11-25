terraform {
  required_version = ">= 1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }

  backend "s3" {
    bucket = "pgr301-2024-terraform-state"
    key    = "terraform/state"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

# SQS Queue
resource "aws_sqs_queue" "image_queue" {
  name = "image-generation-queue-56"
  visibility_timeout_seconds = 60
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_sqs_role_56"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "lambda.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_sqs_policy_56"
  description = "Policy for Lambda to access SQS, S3, CloudWatch Logs, and Bedrock"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]
        Resource = aws_sqs_queue.image_queue.arn
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject"]
        Resource = "arn:aws:s3:::pgr301-couch-explorers/*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow"
        Action   = ["bedrock:InvokeModel"]
        Resource = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-image-generator-v1"
      }
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "lambda_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Lambda Function
resource "aws_lambda_function" "image_lambda" {
  filename         = "${path.module}/lambda_sqs.zip"
  function_name    = "lambda_sqs_image_generator_56"
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_sqs.lambda_handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("${path.module}/lambda_sqs.zip")

  environment {
    variables = {
      BUCKET_NAME      = "pgr301-couch-explorers"
      CANDIDATE_NUMBER = "56"
    }
  }

  timeout = 60
}

# SQS Trigger for Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_queue.arn
  function_name    = aws_lambda_function.image_lambda.arn
  enabled          = true
  batch_size       = 5
}

# CloudWatch Alarm for SQS
resource "aws_cloudwatch_metric_alarm" "sqs_age_alarm" {
  alarm_name          = "sqs-age-of-oldest-message-alarm-56"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 60
  alarm_description   = "Triggered when the age of the oldest message in the SQS queue exceeds the threshold."
  dimensions = {
    QueueName = aws_sqs_queue.image_queue.name
  }
  actions_enabled = true
  alarm_actions   = [aws_sns_topic.sqs_alarm_topic.arn]
}

# SNS Topic for Alarm
resource "aws_sns_topic" "sqs_alarm_topic" {
  name = "sqs-age-alarm-topic-56"
}

# SNS Subscription for Email Notifications
resource "aws_sns_topic_subscription" "sqs_alarm_email_subscription" {
  topic_arn = aws_sns_topic.sqs_alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# Alert Email Variable 
variable "alert_email" {
  description = "Email address for CloudWatch alarm notifications"
  type        = string
}