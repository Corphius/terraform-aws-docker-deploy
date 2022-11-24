variable "region" {
  type    = string
  default = "us-east-1"
}

variable "repository_name" {
  type    = string
  default = "pinnacle-prod"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "image_name" {
  type    = string
  default = "latest"
}
