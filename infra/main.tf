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

# IAM Policy for Lambda (Updated with CloudWatch Permissions)
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_sqs_policy"
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

# Lambda Function (Updated with Candidate Number in Name)
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

  timeout = 30
}

# SQS Trigger for Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.image_queue.arn
  function_name    = aws_lambda_function.image_lambda.arn
  enabled          = true
  batch_size       = 5
}
# Trigger workflow