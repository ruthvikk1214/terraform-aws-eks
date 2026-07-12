data "aws_ssm_parameter" "jenkins_sg_id" {
  name = "/roboshop/dev/jenkins_sg_id"
}
data "aws_ssm_parameter" "jenkins_agent_sg_id" {
  name = "/roboshop/dev/jenkins_agent_sg_id"
}
data "aws_ami" "joindevops" {
  most_recent = true
  owners      = ["973714476881"]

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
  name = "/roboshop/dev/private_subnet_ids"
}
data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/roboshop/dev/public_subnet_ids"
}
data "aws_ami" "sonarqube" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
data "aws_ssm_parameter" "sonar_sg_id" {
  name = "/roboshop/dev/sonarqube_sg_id"
}

