data "aws_ssm_parameter" "jenkins_sg_id" {
  name = "/terraform-aws-eks/jenkins_sg_id"
}
data "aws_ssm_parameter" "jenkins_agent_sg_id" {
  name = "/terraform-aws-eks/jenkins_agent_sg_id"
}
data "aws_ami" "joindevops" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["Redhat-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/terraform-aws-eks/private_subnet_ids"
}