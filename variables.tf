variable "access_key" {
  description = "AWS access key"
  default     = "ACCESSKEY"
}

variable "secret_key" {
  description = "AWS secret access key"
  default     = "SECRETKEY"
}

variable "region" {
  description = "AWS region to host your network"
  default     = "ap-northeast-1"
}

variable "hosted_zone_id" {
  description = "Hosted zone id"
  default     = "HOSTED_ZONE_ID"
}

variable "x_api_key" {
  description = "x-api-key"
  default     = "X_API_KEY"
}

variable "x_via_cloudfront_key" {
  description = "x-via-cloudfront-key"
  default     = "X_VIA_CLOUDFRONT_KEY"
}

variable "todo_app_database_url" {
  description = "todo_app_database_url"
  default     = "TODO_APP_DATABASE_URL"
}

variable "todo_app_rails_master_key" {
  description = "todo_app_rails_master_key"
  default     = "TODO_APP_DATABASE_URL"
}

variable "docker_dir" {
  description = "docker_dir"
  default     = "DOCKER_DIR"
}

variable "my_domain" {
  description = "my_domain"
  default     = "MY_DOMAIN"
}

variable "rds_master_password" {
  description = "my_domain"
  default     = "RDS_MASTER_PASSWORD"
}

variable "ec2_keypair" {
  description = "ec2_keypair"
  default     = "EC2_KEYPAIR"
}
