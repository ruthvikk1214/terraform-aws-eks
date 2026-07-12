resource "aws_route53_record" "jenkins" {
  zone_id = var.zone_id
  name    = "jenkins.${var.domain_name}"
  type    = "A"
  ttl     = 300

  records = [aws_instance.jenkins.public_ip]
}
resource "aws_route53_record" "jenkins_agent" {
  count   = var.jenkins ? 1 : 0
  zone_id = var.zone_id
  name    = "jenkins-agent.${var.domain_name}"
  type    = "A"
  ttl     = 300

  records = [aws_instance.jenkins_agent[0].public_ip]
}

