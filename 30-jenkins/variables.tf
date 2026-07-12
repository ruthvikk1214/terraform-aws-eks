variable "project" {
  description = "The name of the project."
  type        = string
  default     = "roboshop"
}
variable "environment" {
  description = "The deployment environment."
  type        = string
  default     = "dev"
}
variable "domain_name" {
  description = "The domain name for the Route 53 record."
  type        = string
  default     = "rk1214.in"
}

variable "zone_id" {
  description = "The Route 53 hosted zone ID."
  type        = string
  default     = "Z031906510N5GWM6MW07L"
}
variable "sonar" {
  default = false

}
variable "jenkins" {
  default = true
}
