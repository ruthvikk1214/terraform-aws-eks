resource "aws_instance" "jenkins" {
  ami                    = local.ami_id
  instance_type          = "t2.micro"
  subnet_id              = local.public_subnet_id
  vpc_security_group_ids = [local.jenkins_sg_id]
  user_data              = file("${path.module}/user_data.sh")
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

resource "aws_volume_attachment" "jenkins" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.jenkins.id
  instance_id = aws_instance.jenkins.id
}