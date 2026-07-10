data "aws_ssm_parameter" "jenkins_sg_id" {
  name = "/terraform-aws-eks/jenkins_sg_id"
}
data "aws_ssm_parameter" "jenkins_agent_sg_id" {
  name = "/terraform-aws-eks/jenkins_agent_sg_id"
}
data "aws_ssm_parameter" "ami_id" {
  name = "/terraform-aws-eks/ami_id"
}
data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/terraform-aws-eks/private_subnet_ids"
}