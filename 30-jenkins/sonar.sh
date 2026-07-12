#!/bin/bash
set -e

# Update packages
apt-get update -y
apt-get install -y openjdk-17-jdk wget unzip

# Increase system limits required by SonarQube (Elasticsearch)
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
echo "vm.max_map_count=524288" >> /etc/sysctl.conf
echo "fs.file-max=131072" >> /etc/sysctl.conf

# Create sonarqube user
useradd -r -m -U -d /opt/sonarqube -s /bin/bash sonarqube

# Download SonarQube
cd /tmp
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-10.5.1.90531.zip
unzip sonarqube-10.5.1.90531.zip
mv sonarqube-10.5.1.90531/* /opt/sonarqube/
chown -R sonarqube:sonarqube /opt/sonarqube

# Configure SonarQube systemd service
cat <<EOT > /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking
User=sonarqube
Group=sonarqube
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=131072
LimitNPROC=8192
Restart=always

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl enable sonarqube
systemctl start sonarqube
