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
    "ingress",
    "bastion",
    "eks_control_plane", "eks_node", "jenkins", "jenkins_agent", "runner", "openvpn"
  ]
}