#!/bin/bash


sudo growpart /dev/nvme0n1 4
sudo pvresize /dev/nvme0n1p4
sudo lvextend -r -l +100%FREE /dev/RootVG/varVol

sudo curl -L https://pkg.jenkins.io/rpm-stable/jenkins.repo \
-o /etc/yum.repos.d/jenkins.repo
sudo yum install fontconfig java-21-openjdk
sudo yum install jenkins
sudo systemctl daemon-reload

# Install eksctl
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${PLATFORM}.tar.gz" && \
tar -xzf "eksctl_${PLATFORM}.tar.gz" -C /tmp && \
rm "eksctl_${PLATFORM}.tar.gz" && \
sudo install -m 0755 /tmp/eksctl /usr/local/bin/eksctl && \
rm /tmp/eksctl && \

# Install kubectl
curl -LO "https://s3.us-west-2.amazonaws.com/amazon-eks/1.35.2/2026-02-27/bin/linux/amd64/kubectl" && \
chmod +x kubectl && \
sudo mv kubectl /usr/local/bin/kubectl && \

# Verify installation
eksctl version && \
kubectl version --client

git clone https://github.com/ruthvikk1214/eksctl.git
cd eksctl
eksctl create cluster --config-file=eks.yaml