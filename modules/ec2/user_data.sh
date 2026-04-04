#! /bin/bash -xe

#Note: put always -y when you install package via script bash


# docs : https://repost.aws/knowledge-center/ec2-linux-rhel7-rhel8-log-user-data
############## logs of bootstrap######################

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
cat /etc/redhat-release


tee etc/default/grub << 'EOF'
GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0 net.ifnames=0 rd.blacklist=nouveau nvme_core.io_timeout=4294967295"
GRUB_TIMEOUT=0
GRUB_ENABLE_BLSCFG=true
GRUB_DEFAULT=saved
EOF

grub2-mkconfig -o /boot/grub2/grub.cfg
################################################### Note: can't be variable depend on what kind of linux distribution you are using 

#installation ssm agent 
dnf update -y
dnf install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# installation k3s
dnf install -y curl
curl -sfL https://get.k3s.io | sh -  #ok
#sudo swapoff -a
#sudo sed -i '/swap/d' /etc/fstab   #think to open this port 6443, 10250 on security group
ln -s /usr/local/bin/k3s /usr/bin/



# docker runtime for kubernetes
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker


# installation nginx in k3s for private_ip:80 traeffic ingress
cd /
mkdir nginx
cd nginx
touch nginx.yaml

tee nginx.yaml > /dev/null <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: my-nginx
  template:
    metadata:
      labels:
        app: my-nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: my-nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-service
            port:
              number: 80
EOF

k3s kubectl apply -f nginx.yaml



#Installation aws CLI, Need for pull master secret password 
cd /
dnf install -y mariadb
dnf install -y unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
ln -s /usr/local/bin/aws /usr/bin/

aws s3 cp /var/log/user-data.log s3://logshandsonrichanel/  #backup logs into s3

#CLI cmd  aws secretsmanager get-secret-value --secret-id 'rds!db-314b9b7f-265d-4197-bbda-e374ba441163' 

# Connect to db with CLI mysql -h terraform-20260330121002152100000001.cn2g8ss4kgjq.eu-west-1.rds.amazonaws.com -P 3306 -u wordpress -p

#/usr/local/bin/aws





# get cluster credentials 










# ==> work, take time, learn kubernetes 



# cd /
# touch health_check
# tee health_check > /dev/null << 'EOF'

# #!/usr/bin/env python3
# from http.server import BaseHTTPRequestHandler, HTTPServer
# import json

# class HealthHandler(BaseHTTPRequestHandler):
#     def do_GET(self):
#         if self.path == '/health':
#             self.send_response(200)
#             self.send_header('Content-Type', 'application/json')
#             self.end_headers()
#             self.wfile.write(json.dumps({"status":"ok"}).encode())
#         else:
#             print("ici")
#             self.send_response(404)
#             self.end_headers()

# server_address = ('', 8080)  # écoute sur toutes les interfaces IPv4 et IPv6
# httpd = HTTPServer(server_address, HealthHandler)
# print("Serving /health on port 8080")
# httpd.serve_forever()

# EOF

# python3 health_check &

# & ==> no blocking



#Need for  alb and asg 

# dnf install -y nginx
# rm /usr/share/nginx/html/index.html
# echo "<h1> IP-${HOSTNAME} </h1>" | tee /usr/share/nginx/html/index.html


# tee /etc/nginx/nginx.conf > /dev/null <<'EOF'
# user nginx;
# worker_processes auto;
# error_log /var/log/nginx/error.log;
# pid /run/nginx.pid;

# events {
#     worker_connections 1024;
# }

# http {
#     include       /etc/nginx/mime.types;
#     default_type  application/octet-stream;

#     log_format main '$remote_addr - $remote_user [$time_local] "$request" '
#                     '$status $body_bytes_sent "$http_referer" '
#                     '"$http_user_agent" "$http_x_forwarded_for"';
#     access_log /var/log/nginx/access.log main;

#     sendfile        on;
#     keepalive_timeout 65;

#     server {
#         listen 80;
#         listen [::]:80;
#         server_name _;
        
#         root /usr/share/nginx/html;
       

#         location / {

#            index index.html;
#          }
              
#     }
# }
# EOF
# systemctl enable nginx
# systemctl start nginx


# dnf install -y httpd
# systemctl enable httpd
# systemctl start httpd
# echo "<h1> IP-${HOSTNAME} </h1>" | tee /var/www/html/index.html
# # # health check route 
# mkdir -p /var/www/html/health
# echo "OK" | tee /var/www/html/health/index.html


