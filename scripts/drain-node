#! /bin/bash

set -e

INSTANCE_ID=$1

if [[ "$INSTANCE_ID" = "" ]]; then
  echo "Please provide an instance ID"
fi

echo "Fetching IP address of instance $INSTANCE_ID"
IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --output text --query 'Reservations[*].Instances[*].[PublicIpAddress]')

echo "Fetching swarm NodeID for $INSTANCE_ID at $IP"
SWARM_NODE_ID=$(ssh ec2-user@$IP "docker info --format '{{.Swarm.NodeID}}'")

echo "NodeID: $SWARM_NODE_ID"

echo "Setting node to availability: drain"
ssh `make swarm-manager` "docker node update --availability drain $SWARM_NODE_ID"

echo "Stopping containers on node"
STOPPED_COUNT=$(ssh ec2-user@$IP 'docker stop --time 120 `docker ps -q` 2>/dev/null | wc -l' || true)

echo "Stopped $STOPPED_COUNT containers on node"
