#!/bin/bash
set -e

# -------------------------------
# Extend /var filesystem
# -------------------------------
# growpart /dev/nvme0n1 4
# pvresize /dev/nvme0n1p4
# lvextend -r -l +100%FREE /dev/RootVG/varVol

# -------------------------------
# Install required packages
# -------------------------------
dnf update -y
dnf install -y git curl unzip wget fontconfig java-21-openjdk docker awscli

# -------------------------------
# Install Jenkins
# -------------------------------
curl -fsSL https://pkg.jenkins.io/rpm-stable/jenkins.repo \
-o /etc/yum.repos.d/jenkins.repo

rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

dnf install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# -------------------------------
# Configure Docker
# -------------------------------
systemctl enable docker
systemctl start docker

usermod -aG docker ec2-user
usermod -aG docker jenkins

# -------------------------------
# Install eksctl
# -------------------------------
ARCH=amd64
PLATFORM=$(uname -s)_${ARCH}

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz"

tar -xzf eksctl_${PLATFORM}.tar.gz -C /tmp

install -m 0755 /tmp/eksctl /usr/local/bin/eksctl

rm -f eksctl_${PLATFORM}.tar.gz
rm -f /tmp/eksctl

# -------------------------------
# Install kubectl
# -------------------------------
curl -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.2/2026-02-27/bin/linux/amd64/kubectl"

chmod +x kubectl

mv kubectl /usr/local/bin/

# -------------------------------
# Verify installations
# -------------------------------
java -version
git --version
docker --version
aws --version
eksctl version
kubectl version --client

echo "Jenkins installation completed successfully."