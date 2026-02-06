# EC2 Schedules Module

This module creates an EventBridge schedule to start and stop EC2 instances using a Lambda function.

## Usage example

```hcl
module "ec2_schedules" {
  source = "./modules/ec2-schedules"

  name_prefix       = "app"
  instance_ids      = ["i-0123456789abcdef0", "i-0abcdef1234567890"]
  up_schedule       = "cron(0 8 ? * MON-FRI *)"
  down_schedule     = "cron(0 20 ? * MON-FRI *)"
  log_retention_days = 14

  tags = {
    Environment = "dev"
  }
}
```

## Variables

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name_prefix` | `string` | n/a | Prefix for stack resources. |
| `up_schedule` | `string` | n/a | EventBridge cron/rate expression to start instances. |
| `down_schedule` | `string` | n/a | EventBridge cron/rate expression to stop instances. |
| `instance_ids` | `list(string)` | n/a | EC2 instance IDs to manage. |
| `log_retention_days` | `number` | `14` | CloudWatch log retention in days. |
| `tags` | `map(string)` | `{}` | Common tags. |

## Outputs

| Name | Description |
| --- | --- |
| `lambda_function_name` | Lambda function name. |
| `event_rule_up_arn` | Start schedule rule ARN. |
| `event_rule_down_arn` | Stop schedule rule ARN. |
