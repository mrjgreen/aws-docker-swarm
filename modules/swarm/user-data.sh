#! /bin/bash
set -e

# Make sure we have all the latest updates when we launch this instance
yum update -y
yum upgrade -y

# Create a weekly cron job to give us the latest security updates
echo "/usr/bin/yum update --security -y" > /etc/cron.weekly/yumsecurity.cron

# Install some basic tools for adhoc monitoring and debugging on the box
yum install -y htop iotop jq

# Install docker
yum install -y docker

# Docker config folder isn't created until after docker is started, so we create it here
mkdir -p /etc/docker && chmod 0700 /etc/docker

# We want experimental support to allow us to use "docker service logs <name>"
echo '{"experimental": true}' > /etc/docker/daemon.json

# Start docker now and enable auto start on boot
service docker start && chkconfig docker on

# Allow the ec2-user to run docker commands without sudo
usermod -a -G docker ec2-user

# Every time we stop and recreate our app, old containers, images and networks will be left over
# Run this every hour to clean them up
echo "docker system prune --force" > /etc/cron.hourly/docker-cleanup.cron

# Get local ip from the instance metadata, we need to specify this when creating/joining the swarm
PRIVATE_IP=$(curl -fsS http://instance-data/latest/meta-data/local-ipv4)

# One shot a custom container with a small script to automatically init swarm, using S3 for discovery
docker run -d --restart on-failure:15 \
-e SWARM_DISCOVERY_BUCKET=${SWARM_DISCOVERY_BUCKET} \
-e ROLE=${ROLE} \
-e NODE_IP=$PRIVATE_IP \
-v /var/run/docker.sock:/var/run/docker.sock \
mrjgreen/aws-swarm-init
