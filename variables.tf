variable "region" {
  type        = string
  description = "bitte die AWS Region angeben"
  default     = "eu-central-1"
}

variable "node_count" {
  type        = number
  description = "bitte die Anzahl der Webserver angeben"
  default     = 4
}
