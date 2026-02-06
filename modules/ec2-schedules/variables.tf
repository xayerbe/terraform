variable "name_prefix" {
  type        = string
  description = "Prefijo para los recursos del stack."
}

variable "up_schedule" {
  type        = string
  description = "Expresión cron/rate de EventBridge para encender instancias."
}

variable "down_schedule" {
  type        = string
  description = "Expresión cron/rate de EventBridge para apagar instancias."
}

variable "instance_ids" {
  type        = list(string)
  description = "IDs de instancias EC2 a controlar."
}

variable "log_retention_days" {
  type        = number
  description = "Días de retención del log group."
  default     = 14
}

variable "tags" {
  type        = map(string)
  description = "Tags comunes."
  default     = {}
}
