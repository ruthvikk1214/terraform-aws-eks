
resource "aws_security_group_rule" "bastion_internet" { #bastion accepting connection from internet
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.my_ip]

  security_group_id = local.bastion_sg_id
}

resource "aws_security_group_rule" "mongodb_bastion" { #mongo accepting connection from bastion to configure mongodb
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.mongodb_sg_id
}

resource "aws_security_group_rule" "redis_bastion" { #redis accepting connection from bastion to configure redis
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.redis_sg_id
}

resource "aws_security_group_rule" "mysql_bastion" { #mysql accepting connections from bastion to configure mysql
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.mysql_sg_id
}

resource "aws_security_group_rule" "rabbitmq_bastion" { #rabbitmq accepting connections from bastion to configure rabbitmq
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.rabbitmq_sg_id
}
/* 
resource "aws_security_group_rule" "ingress_alb_public" { #openvpn accepting connections from internet to serve requests
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.ingress_alb_sg_id
} */

resource "aws_security_group_rule" "openvpn_public_443" { #openvpn accepting connections from internet to serve requests
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}
resource "aws_security_group_rule" "openvpn_public_943" { #openvpn accepting connections from internet to serve requests
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.openvpn_sg_id
}

resource "aws_security_group_rule" "eks_node_bastion" { #openvpn accepting connections from internet to serve requests
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.eks_node_sg_id
}
resource "aws_security_group_rule" "eks_control_plane_eks_node" { #openvpn accepting connections from internet to serve requests
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = local.eks_node_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}
resource "aws_security_group_rule" "eks_node_eks_control_plane" { #openvpn accepting connections from internet to serve requests
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = local.eks_control_plane_sg_id
  security_group_id        = local.eks_node_sg_id
}
resource "aws_security_group_rule" "eks_node_vpc_cidr" { #openvpn accepting connections from internet to serve requests
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["10.0.0.0/16"]
  security_group_id = local.eks_node_sg_id
}

resource "aws_security_group_rule" "jenkins_agent_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.jenkins_agent_sg_id
}
resource "aws_security_group_rule" "jenkins_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.jenkins_sg_id
}
resource "aws_security_group_rule" "jenkins_public" {
  type      = "ingress"
  from_port = 8080
  to_port   = 8080
  protocol  = "tcp" # all traffic
  # VPC CIDR
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.jenkins_sg_id
}
resource "aws_security_group_rule" "eks_control_plane_runner" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.runner_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}
resource "aws_security_group_rule" "runner_ssh" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  # Where traffic is coming from
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = local.runner_sg_id
}
resource "aws_security_group_rule" "eks_control_plane_jenkins_agent" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.jenkins_agent_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}
resource "aws_security_group_rule" "mysql_eks_node" {
  type      = "ingress"
  from_port = 3306
  to_port   = 3306
  protocol  = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.eks_node_sg_id
  security_group_id        = local.mysql_sg_id
}
resource "aws_security_group_rule" "eks_control_plane_bastion" {
  type      = "ingress"
  from_port = 443
  to_port   = 443
  protocol  = "tcp"
  # Where traffic is coming from
  source_security_group_id = local.bastion_sg_id
  security_group_id        = local.eks_control_plane_sg_id
}
