resource "aws_instance" "jenkins" {
  ami                         = local.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = local.public_subnet_id
  vpc_security_group_ids      = [local.jenkins_sg_id]
  user_data                   = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }
  tags = {
    Name        = "jenkins"
    Environment = var.environment
    Project     = var.project
  }
}
resource "aws_ebs_volume" "jenkins" {
  availability_zone = aws_instance.jenkins.availability_zone
  size              = 30
  type              = "gp3"

  tags = {
    Name = "jenkins-extra-disk"
  }
}

resource "aws_instance" "sonarqube" {
  count                  = var.sonar ? 1 : 0
  ami                    = local.sonar_ami_id
  instance_type          = "t3.large"
  vpc_security_group_ids = [local.sonar_sg_id]
  subnet_id              = local.public_subnet_id #replace your Subnet in default VPC
  key_name               = "daws-88s"
  # need more for terraform
  root_block_device {
    volume_size = 50
    volume_type = "gp3" # or "gp2", depending on your preference
  }
  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-sonar"
    }
  )
}
resource "aws_instance" "jenkins_agent" {
  count                  = var.jenkins ? 1 : 0
  ami                    = local.ami_id
  instance_type          = "t3.micro"
  subnet_id              = local.public_subnet_id
  vpc_security_group_ids = [local.jenkins_agent_sg_id]
  user_data              = file("jenkins-agent.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    tags = merge(
      {
        Name = "${var.project}-${var.environment}-jenkins-agent"
      },
      local.common_tags
    )
  }

  tags = merge(
    {
      Name = "${var.project}-${var.environment}-jenkins-agent"
    },
    local.common_tags
  )
}

