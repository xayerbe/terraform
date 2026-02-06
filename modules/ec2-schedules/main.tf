locals {
  function_name = "${var.name_prefix}-ec2-scheduler"
}

data "aws_caller_identity" "current" {}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda/lambda.py"
  output_path = "${path.module}/lambda/lambda.zip"
}

resource "aws_iam_role" "lambda" {
  name = "${var.name_prefix}-ec2-scheduler-role"

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

  tags = var.tags
}

resource "aws_iam_policy" "lambda" {
  name = "${var.name_prefix}-ec2-scheduler-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ec2:StartInstances", "ec2:StopInstances", "ec2:DescribeInstances"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

resource "aws_lambda_function" "this" {
  function_name    = local.function_name
  role             = aws_iam_role.lambda.arn
  handler          = "lambda.handler"
  runtime          = "python3.11"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      INSTANCE_IDS = jsonencode(var.instance_ids)
    }
  }

  tags = var.tags

  depends_on = [aws_cloudwatch_log_group.lambda]
}

resource "aws_cloudwatch_event_rule" "up" {
  name                = "${var.name_prefix}-ec2-scheduler-up"
  schedule_expression = var.up_schedule
  tags                = var.tags
}

resource "aws_cloudwatch_event_rule" "down" {
  name                = "${var.name_prefix}-ec2-scheduler-down"
  schedule_expression = var.down_schedule
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "up" {
  rule      = aws_cloudwatch_event_rule.up.name
  target_id = "start"
  arn       = aws_lambda_function.this.arn
  input     = jsonencode({ action = "start" })
}

resource "aws_cloudwatch_event_target" "down" {
  rule      = aws_cloudwatch_event_rule.down.name
  target_id = "stop"
  arn       = aws_lambda_function.this.arn
  input     = jsonencode({ action = "stop" })
}

resource "aws_lambda_permission" "allow_events_up" {
  statement_id  = "AllowExecutionFromEventBridgeUp"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.up.arn
}

resource "aws_lambda_permission" "allow_events_down" {
  statement_id  = "AllowExecutionFromEventBridgeDown"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.down.arn
}
