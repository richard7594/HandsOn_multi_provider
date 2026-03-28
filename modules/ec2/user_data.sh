#! /bin/bash

#Note: put always -y when you install package via script bash

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


#Need for  alb and asg 
dnf install -y httpd
systemctl enable httpd
systemctl start httpd
echo "<h1> ${HOSTNAME} </h1>" | tee /var/www/html/index.html