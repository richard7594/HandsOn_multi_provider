#! /bin/bash

#installation ssm agent 
dnf update
dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# installation k3s
dnf install -y curl
curl -sfL https://get.k3s.io | sh -  #ok
#sudo swapoff -a
#sudo sed -i '/swap/d' /etc/fstab   #think to open this port 6443, 10250 on security group