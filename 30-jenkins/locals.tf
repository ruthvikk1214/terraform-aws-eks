locals {
  ami_id =  data.aws_ami.joindevops.id
  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
  jenkins_sg_id             = aws_security_group.jenkins.id
}