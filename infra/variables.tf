variable "region" {
  description = "AWS region to deploy resources to"
  default     = "us-east-1"
}

variable "prefix" {
  description = "Prefix to use for resource names"
  default     = "django-k8s"
}

variable "db_password" {
  description = "Password for the RDS database instance"
  type        = string
  sensitive   = true
  default     = "samplepassword123"
}
