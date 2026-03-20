variable "region" {
  description = "AWS region to deploy resources to"
  default     = "us-east-1"
}

variable "prefix" {
  description = "Prefix to use for resource names"
  default     = "django-k8s"
}
