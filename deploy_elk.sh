#!/bin/bash

# Define variables
EC2_USER=ec2-user
EC2_IP=13.209.22.119
PEM_PATH=~/Desktop/aikey.pem
LOCAL_PATH=$(dirname "$0")
REMOTE_PATH=/home/$EC2_USER/elk

# Copy files to EC2
echo "Copying files to EC2..."
scp -i $PEM_PATH -r $LOCAL_PATH/docker-compose.yml $LOCAL_PATH/logstash $EC2_USER@$EC2_IP:$REMOTE_PATH

# SSH into EC2 and run Docker Compose
echo "Connecting to EC2 and starting Docker Compose..."
ssh -t -i $PEM_PATH $EC2_USER@$EC2_IP << EOF
  sudo systemctl start docker
  cd $REMOTE_PATH
  sudo /usr/local/bin/docker-compose down
  sudo /usr/local/bin/docker-compose up -d
EOF

echo "ELK stack deployed successfully!"
