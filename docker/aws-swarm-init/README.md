# Docker Swarm Discovery

While docker swarm provides discovery for services once it's running, setting up the swarm requires manual initialization of the managers.

Adding new nodes to the cluster requires information provided by the first manager when the swarm is created:

 * The IP address of at least one available manager
 * A join token

## Solution

This docker container wraps a simple python script which uses an S3 bucket to store the state of the swarm once it's created, or creates a new swarm if no state already exists in the bucket.

## Installation

##### On AWS EC2

You should configure the instance IAM roles to have [access to the bucket as shown here](#iam-policy).

```
NODE_IP=$(curl -fsS http://instance-data/latest/meta-data/local-ipv4)
SWARM_DISCOVERY_BUCKET="my-bucket"
ROLE="manager" # or "worker"

docker run -d --restart on-failure:5 \
-e SWARM_DISCOVERY_BUCKET=${SWARM_DISCOVERY_BUCKET} \
-e ROLE=${ROLE} \
-e NODE_IP=${NODE_IP} \
-v /var/run/docker.sock:/var/run/docker.sock \
mrjgreen/aws-swarm-init
```

##### Elsewhere

You should configure the keys with an IAM policy that has [access to the bucket as shown here](#iam-policy).

```
NODE_IP="10.0.0.2" # Set to the public/private IP your node will communicate on
SWARM_DISCOVERY_BUCKET="my-bucket"
ROLE="manager" # or "worker"
AWS_ACCESS_KEY_ID="MY_AWS_ACCESS_KEY_ID"
AWS_SECRET_ACCESS_KEY="MY_AWS_SECRET_ACCESS_KEY"

docker run -d --restart on-failure:5 \
-e SWARM_DISCOVERY_BUCKET=${SWARM_DISCOVERY_BUCKET} \
-e ROLE=${ROLE} \
-e NODE_IP=${NODE_IP} \
-e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
-e MY_AWS_SECRET_ACCESS_KEY=${MY_AWS_SECRET_ACCESS_KEY} \
-v /var/run/docker.sock:/var/run/docker.sock \
mrjgreen/aws-swarm-init
```

## IAM Policy
```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-bucket/*",
      "actions": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListObjects"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::my-bucket",
      "actions": [
        "s3:ListBucket"
      ]
    }
  ]
}
```

## Building

```
docker build -t mrjgreen/aws-swarm-init .
docker push mrjgreen/aws-swarm-init
```
