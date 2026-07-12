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
# Grow Partition and LVM Volume
# -------------------------------
if [ -b /dev/nvme0n1 ]; then
    growpart /dev/nvme0n1 4 || true
    pvresize /dev/nvme0n1p4 || true
elif [ -b /dev/xvda ]; then
    growpart /dev/xvda 4 || true
    pvresize /dev/xvda4 || true
fi

lvextend -r -l +100%FREE /dev/RootVG/varVol || true

# -------------------------------
# Install required packages
# -------------------------------
dnf install -y git curl unzip wget fontconfig java-21-openjdk

# -------------------------------
# Install Jenkins
# -------------------------------
curl -fsSL https://pkg.jenkins.io/rpm-stable/jenkins.repo \
-o /etc/yum.repos.d/jenkins.repo

rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key
sudo dnf install -y java-21-openjdk
dnf install -y jenkins

systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# -------------------------------
# Configure Docker
# -------------------------------
sudo dnf remove -y podman-docker

sudo dnf install -y dnf-plugins-core

sudo dnf config-manager --add-repo \
https://download.docker.com/linux/centos/docker-ce.repo

sudo dnf install -y \
docker-ce \
docker-ce-cli \
containerd.io \
docker-buildx-plugin \
docker-compose-plugin

sudo systemctl enable --now docker

sudo usermod -aG docker jenkins
sudo systemctl restart jenkins


# -------------------------------
# Verify installations
# -------------------------------
java -version
git --version
docker --version
aws --version
eksctl version
kubectl version --client

# -------------------------------
# Automate EKS Cluster Creation
# -------------------------------
echo "Starting automated EKS cluster creation in the background..."
cat <<'EOF' > /tmp/create_cluster.sh
#!/bin/bash
set -e
cd /tmp
git clone https://github.com/ruthvikk1214/eksctl.git
cd eksctl
eksctl create cluster -f eks.yaml
EOF
chmod +x /tmp/create_cluster.sh
nohup /tmp/create_cluster.sh > /var/log/eks-creation.log 2>&1 &

echo "Jenkins installation completed successfully."