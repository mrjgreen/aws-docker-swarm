# We set the account ID here, to avoid mistakes across applications
account_id="0000000000"

# The region to deploy the resources
region="eu-west-1"

# This needs to be different for every deployment within a region
application="SampleApp"

# Set up a key pair in AWS and add the name here to allow SSH access to the instances
key_name="MyKeyPair"

# Set the IP ranges from which to allow SSH access to the instances
ssh_access=["0.0.0.0/0"]

# If you want to use DNS to address groups of nodes in your swarm, you must add a Zone ID
# or create a new one using terraform
route53_zone_id="Z********"

# If you want to use DNS to address groups of nodes in your swarm, you must add a domain name
# (root domain must be under the control of "route53_zone_id" added above)
domain="app.mydomain.tld"

# Set the instance type to use
instance_type="t2.nano"

# Set the root EBS volume size for the swarm instances
volume_size=12

# Set the number of instances to run as managers
swarm_manager_count=1

# Set the number of instances to run as workers
swarm_worker_count=1
