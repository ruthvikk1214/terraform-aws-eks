#!/bin/bash
set -e


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
pvcreate /dev/nvme1n1
vgextend RootVG /dev/nvme1n1
lvextend -r -l +100%FREE /dev/RootVG/varVol

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
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins



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