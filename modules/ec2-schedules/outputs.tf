output "lambda_function_name" {
  description = "Nombre de la Lambda creada."
  value       = aws_lambda_function.this.function_name
}

output "event_rule_up_arn" {
  description = "ARN del rule de encendido."
  value       = aws_cloudwatch_event_rule.up.arn
}

output "event_rule_down_arn" {
  description = "ARN del rule de apagado."
  value       = aws_cloudwatch_event_rule.down.arn
}
