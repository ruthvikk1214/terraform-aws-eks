variable "project" {
  default = "roboshop"
}
variable "environment" {
  default = "dev"
}
variable "sg_names" {
  type = list(string)

  default = [
    "mongodb",
    "redis",
    "mysql",
    "rabbitmq",
    "ingress_alb",
    "bastion",
    "eks_control_plane","eks_node","jenkins","jenkins_agent"
  ]
}